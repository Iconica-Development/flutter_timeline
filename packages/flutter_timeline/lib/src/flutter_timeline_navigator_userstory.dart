// SPDX-FileCopyrightText: 2024 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause

import 'package:flutter/material.dart';
import 'package:flutter_timeline/flutter_timeline.dart';

Widget timeLineNavigatorUserStory({
  required BuildContext context,
  TimelineUserStoryConfiguration? configuration,
}) {
  var config = configuration ??
      TimelineUserStoryConfiguration(
        userId: 'test_user',
        service: TimelineService(
          postService: LocalTimelinePostService(),
        ),
        optionsBuilder: (context) => const TimelineOptions(),
      );

  return _timelineScreenRoute(configuration: config, context: context);
}

Widget _timelineScreenRoute({
  required BuildContext context,
  TimelineUserStoryConfiguration? configuration,
}) {
  var config = configuration ??
      TimelineUserStoryConfiguration(
        userId: 'test_user',
        service: TimelineService(
          postService: LocalTimelinePostService(),
        ),
        optionsBuilder: (context) => const TimelineOptions(),
      );

  return TimelineScreen(
    service: config.service,
    options: config.optionsBuilder(context),
    userId: config.userId,
    onPostTap: (post) async =>
        config.onPostTap?.call(context, post) ??
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => _postDetailScreenRoute(
              configuration: config,
              context: context,
              post: post,
            ),
          ),
        ),
    onUserTap: (userId) {
      config.onUserTap?.call(context, userId);
    },
    filterEnabled: config.filterEnabled,
    postWidgetBuilder: config.postWidgetBuilder,
  );
}

Widget _postDetailScreenRoute({
  required BuildContext context,
  required TimelinePost post,
  TimelineUserStoryConfiguration? configuration,
}) {
  var config = configuration ??
      TimelineUserStoryConfiguration(
        userId: 'test_user',
        service: TimelineService(
          postService: LocalTimelinePostService(),
        ),
        optionsBuilder: (context) => const TimelineOptions(),
      );

  return TimelinePostScreen(
    userId: config.userId,
    service: config.service,
    options: config.optionsBuilder(context),
    post: post,
    onPostDelete: () async {
      config.onPostDelete?.call(context, post) ??
          await config.service.postService.deletePost(post);
    },
  );
}
