// SPDX-FileCopyrightText: 2023 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_timeline_interface/flutter_timeline_interface.dart';
import 'package:flutter_timeline_view/flutter_timeline_view.dart';

class TimelineScreen extends StatefulWidget {
  const TimelineScreen({
    required this.userId,
    required this.service,
    required this.options,
    required this.onPostTap,
    this.scrollController,
    this.onUserTap,
    this.posts,
    this.timelineCategory,
    this.postWidgetBuilder,
    this.filterEnabled = false,
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
  final String? timelineCategory;

  /// This is used if you want to pass in a list of posts instead
  /// of fetching them from the service
  final List<TimelinePost>? posts;

  /// Called when a post is tapped
  final Function(TimelinePost) onPostTap;

  /// If this is not null, the user can tap on the user avatar or name
  final Function(String userId)? onUserTap;

  /// Override the standard postwidget
  final Widget Function(TimelinePost post)? postWidgetBuilder;

  /// if true the filter textfield is enabled.
  final bool filterEnabled;

  @override
  State<TimelineScreen> createState() => _TimelineScreenState();
}

class _TimelineScreenState extends State<TimelineScreen> {
  late ScrollController controller;
  late var textFieldController = TextEditingController(
    text: widget.options.filterOptions.initialFilterWord,
  );
  late var service = widget.service;

  bool isLoading = true;

  late var category = widget.timelineCategory;

  late var filterWord = widget.options.filterOptions.initialFilterWord;

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
        var posts = widget.posts ?? service.getPosts(category);

        if (widget.filterEnabled && filterWord != null) {
          if (service is TimelineFilterService?) {
            posts =
                (service as TimelineFilterService).filterPosts(filterWord!, {});
          } else {
            debugPrint('Timeline service needs to mixin'
                ' with TimelineFilterService');
          }
        }

        posts = posts
            .where(
              (p) => category == null || p.category == category,
            )
            .toList();

        // sort posts by date
        if (widget.options.sortPostsAscending != null) {
          posts.sort(
            (a, b) => widget.options.sortPostsAscending!
                ? a.createdAt.compareTo(b.createdAt)
                : b.createdAt.compareTo(a.createdAt),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: widget.options.padding.top,
            ),
            if (widget.filterEnabled) ...[
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: widget.options.padding.horizontal,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: TextField(
                        controller: textFieldController,
                        onChanged: (value) {
                          setState(() {
                            filterWord = value;
                          });
                        },
                        decoration: InputDecoration(
                          hintText: widget.options.translations.searchHint,
                          suffixIconConstraints:
                              const BoxConstraints(maxHeight: 14),
                          contentPadding: const EdgeInsets.only(
                            left: 12,
                            right: 12,
                            bottom: -10,
                          ),
                          suffixIcon: const Padding(
                            padding: EdgeInsets.only(right: 12),
                            child: Icon(Icons.search),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          textFieldController.clear();
                          filterWord = null;
                          widget.options.filterOptions.onFilterEnabledChange
                              ?.call(filterEnabled: false);
                        });
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(8),
                        child: Icon(
                          Icons.close,
                          color: Color(0xFF000000),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 24,
              ),
            ],
            CategorySelector(
              filter: category,
              options: widget.options,
              onTapCategory: (categoryKey) {
                setState(() {
                  category = categoryKey;
                });
              },
            ),
            const SizedBox(
              height: 12,
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
                        child: widget.postWidgetBuilder?.call(post) ??
                            TimelinePostWidget(
                              service: widget.service,
                              userId: widget.userId,
                              options: widget.options,
                              post: post,
                              onTap: () => widget.onPostTap(post),
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
                            category == null
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
            SizedBox(
              height: widget.options.padding.bottom,
            ),
          ],
        );
      },
    );
  }

  Future<void> loadPosts() async {
    if (widget.posts != null) return;
    try {
      await service.fetchPosts(category);
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
