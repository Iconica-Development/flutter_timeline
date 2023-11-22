// SPDX-FileCopyrightText: 2023 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_timeline_interface/flutter_timeline_interface.dart';
import 'package:flutter_timeline_view/src/config/timeline_options.dart';
import 'package:flutter_timeline_view/src/widgets/timeline_post_widget.dart';

class TimelineScreen extends StatefulWidget {
  const TimelineScreen({
    required this.userId,
    required this.options,
    required this.onPostTap,
    required this.service,
    this.onUserTap,
    this.posts,
    this.controller,
    this.timelineCategoryFilter,
    this.timelinePostHeight,
    this.padding = const EdgeInsets.symmetric(vertical: 12.0),
    super.key,
  });

  /// The user id of the current user
  final String userId;

  /// The service to use for fetching and manipulating posts
  final TimelineService service;

  /// All the configuration options for the timelinescreens and widgets
  final TimelineOptions options;

  /// The controller for the scroll view
  final ScrollController? controller;

  final String? timelineCategoryFilter;

  /// The height of a post in the timeline
  final double? timelinePostHeight;

  /// This is used if you want to pass in a list of posts instead
  /// of fetching them from the service
  final List<TimelinePost>? posts;

  /// Called when a post is tapped
  final Function(TimelinePost) onPostTap;

  /// If this is not null, the user can tap on the user avatar or name
  final Function(String userId)? onUserTap;

  /// The padding between posts in the timeline
  final EdgeInsets padding;

  @override
  State<TimelineScreen> createState() => _TimelineScreenState();
}

class _TimelineScreenState extends State<TimelineScreen> {
  late ScrollController controller;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    controller = widget.controller ?? ScrollController();
    unawaited(loadPosts());
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading && widget.posts == null) {
      return const Center(child: CircularProgressIndicator());
    }

    // Build the list of posts
    return ListenableBuilder(
      listenable: widget.service,
      builder: (context, _) {
        var posts = widget.posts ??
            widget.service.getPosts(widget.timelineCategoryFilter);
        posts = posts
            .where(
              (p) =>
                  widget.timelineCategoryFilter == null ||
                  p.category == widget.timelineCategoryFilter,
            )
            .toList();

        // sort posts by date
        posts.sort(
          (a, b) => widget.options.sortPostsAscending
              ? a.createdAt.compareTo(b.createdAt)
              : b.createdAt.compareTo(a.createdAt),
        );
        return SingleChildScrollView(
          controller: controller,
          child: Column(
            children: [
              ...posts.map(
                (post) => Padding(
                  padding: widget.padding,
                  child: TimelinePostWidget(
                    userId: widget.userId,
                    options: widget.options,
                    post: post,
                    height: widget.timelinePostHeight,
                    onTap: () => widget.onPostTap.call(post),
                    onTapLike: () async =>
                        widget.service.likePost(widget.userId, post),
                    onTapUnlike: () async =>
                        widget.service.unlikePost(widget.userId, post),
                    onPostDelete: () async => widget.service.deletePost(post),
                    onUserTap: widget.onUserTap,
                  ),
                ),
              ),
              if (posts.isEmpty)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      widget.timelineCategoryFilter == null
                          ? widget.options.translations.noPosts
                          : widget.options.translations.noPostsWithFilter,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Future<void> loadPosts() async {
    if (widget.posts != null) return;
    try {
      await widget.service.fetchPosts(widget.timelineCategoryFilter);
      setState(() {
        isLoading = false;
      });
    } on Exception catch (e) {
      // Handle errors here
      debugPrint('Error loading posts: $e');
      setState(() {
        isLoading = false;
      });
    }
  }
}
