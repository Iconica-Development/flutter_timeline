// SPDX-FileCopyrightText: 2023 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_timeline_interface/flutter_timeline_interface.dart';
import 'package:flutter_timeline_view/flutter_timeline_view.dart';
import 'package:flutter_timeline_view/src/widgets/category_selector.dart';

class TimelineScreen extends StatefulWidget {
  const TimelineScreen({
    required this.userId,
    required this.service,
    required this.options,
    this.scrollController,
    this.onPostTap,
    this.onUserTap,
    this.posts,
    this.timelineCategoryFilter,
    this.postWidget,
    super.key,
  });

  /// The user id of the current user
  final String userId;

  /// The service to use for fetching and manipulating posts
  final TimelineService service;

  /// All the configuration options for the timelinescreens and widgets
  final TimelineOptions options;

  /// The controller for the scroll view
  final ScrollController? scrollController;

  /// The string to filter the timeline by category
  final String? timelineCategoryFilter;

  /// This is used if you want to pass in a list of posts instead
  /// of fetching them from the service
  final List<TimelinePost>? posts;

  /// Called when a post is tapped
  final Function(TimelinePost)? onPostTap;

  /// If this is not null, the user can tap on the user avatar or name
  final Function(String userId)? onUserTap;

  /// Override the standard postwidget
  final Widget Function(TimelinePost post)? postWidget;

  @override
  State<TimelineScreen> createState() => _TimelineScreenState();
}

class _TimelineScreenState extends State<TimelineScreen> {
  late ScrollController controller;
  late var service = widget.service;

  bool isLoading = true;

  late var filter = widget.timelineCategoryFilter;

  @override
  void initState() {
    super.initState();
    controller = widget.scrollController ?? ScrollController();
    unawaited(loadPosts());
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading && widget.posts == null) {
      return const Center(child: CircularProgressIndicator());
    }

    // Build the list of posts
    return ListenableBuilder(
      listenable: service,
      builder: (context, _) {
        var posts = widget.posts ?? service.getPosts(filter);
        posts = posts
            .where(
              (p) => filter == null || p.category == filter,
            )
            .toList();

        // sort posts by date
        posts.sort(
          (a, b) => widget.options.sortPostsAscending
              ? a.createdAt.compareTo(b.createdAt)
              : b.createdAt.compareTo(a.createdAt),
        );

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CategorySelector(
              filter: filter,
              options: widget.options,
              onTapCategory: (categoryKey) {
                setState(() {
                  filter = categoryKey;
                });
              },
            ),
            Expanded(
              child: SingleChildScrollView(
                controller: controller,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ...posts.map(
                      (post) => Padding(
                        padding: widget.options.postPadding,
                        child: widget.postWidget?.call(post) ??
                            TimelinePostWidget(
                              service: widget.service,
                              userId: widget.userId,
                              options: widget.options,
                              post: post,
                              onTap: () async {
                                if (widget.onPostTap != null) {
                                  widget.onPostTap!.call(post);
                                  return;
                                }

                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Scaffold(
                                      body: TimelinePostScreen(
                                        userId: widget.userId,
                                        service: widget.service,
                                        options: widget.options,
                                        post: post,
                                        onPostDelete: () {
                                          widget.service.deletePost(post);
                                        },
                                      ),
                                    ),
                                  ),
                                );
                              },
                              onTapLike: () async =>
                                  service.likePost(widget.userId, post),
                              onTapUnlike: () async =>
                                  service.unlikePost(widget.userId, post),
                              onPostDelete: () async =>
                                  service.deletePost(post),
                              onUserTap: widget.onUserTap,
                            ),
                      ),
                    ),
                    if (posts.isEmpty)
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            filter == null
                                ? widget.options.translations.noPosts
                                : widget.options.translations.noPostsWithFilter,
                            style: widget.options.theme.textStyles.noPostsStyle,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> loadPosts() async {
    if (widget.posts != null) return;
    try {
      await service.fetchPosts(filter);
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
