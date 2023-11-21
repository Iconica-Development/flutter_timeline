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
    required this.posts,
    required this.onPostTap,
    required this.service,
    this.controller,
    this.timelineCategoryFilter,
    this.timelinePostHeight = 100.0,
    super.key,
  });

  /// The user id of the current user
  final String userId;

  final TimelineService service;

  final TimelineOptions options;

  final ScrollController? controller;

  final String? timelineCategoryFilter;

  final double timelinePostHeight;

  final List<TimelinePost> posts;

  final Function(TimelinePost) onPostTap;

  @override
  State<TimelineScreen> createState() => _TimelineScreenState();
}

class _TimelineScreenState extends State<TimelineScreen> {
  late ScrollController controller;
  late List<TimelinePost> posts;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    controller = widget.controller ?? ScrollController();
    unawaited(loadPosts());
  }

  Future<void> loadPosts() async {
    try {
      // Fetching posts from the service
      var fetchedPosts =
          await widget.service.fetchPosts(widget.timelineCategoryFilter);
      setState(() {
        posts = fetchedPosts;
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

  void updatePostInList(TimelinePost updatedPost) {
    if (posts.any((p) => p.id == updatedPost.id))
      setState(() {
        posts = posts
            .map((p) => (p.id == updatedPost.id) ? updatedPost : p)
            .toList();
      });
    else {
      setState(() {
        posts = [updatedPost, ...posts];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      // Show loading indicator while data is being fetched
      return const Center(child: CircularProgressIndicator());
    }

    // Build the list of posts
    return SingleChildScrollView(
      controller: controller,
      child: Column(
        children: posts
            .map(
              (post) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: TimelinePostWidget(
                  userId: widget.userId,
                  options: widget.options,
                  post: post,
                  height: widget.timelinePostHeight,
                  onTap: () => widget.onPostTap.call(post),
                  onTapLike: () async => updatePostInList(
                    await widget.service.likePost(widget.userId, post),
                  ),
                  onTapUnlike: () async => updatePostInList(
                    await widget.service.unlikePost(widget.userId, post),
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
