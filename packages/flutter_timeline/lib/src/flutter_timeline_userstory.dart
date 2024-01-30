// SPDX-FileCopyrightText: 2023 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause

import 'package:flutter/material.dart';
import 'package:flutter_timeline/flutter_timeline.dart';
import 'package:flutter_timeline/src/go_router.dart';
import 'package:go_router/go_router.dart';

List<GoRoute> getTimelineStoryRoutes({
  TimelineUserStoryConfiguration? configuration,
}) {
  var config = configuration ?? TimelineUserStoryConfiguration(
    userId: 'test_user',
    service: TimelineService(
      postService: LocalTimelinePostService(),
    ),
    optionsBuilder: (context) => const TimelineOptions(),
  );

  return <GoRoute>[
    GoRoute(
      path: TimelineUserStoryRoutes.timelineHome,
      pageBuilder: (context, state) {
        var timelineScreen = TimelineScreen(
          userId: config.userId,
          onUserTap: (user) => config.onUserTap?.call(context, user),
          service: config.service,
          options: config.optionsBuilder(context),
          onPostTap: (post) async =>
              config.onPostTap?.call(context, post) ??
              await context.push(
                TimelineUserStoryRoutes.timelineViewPath(post.id),
              ),
          filterEnabled: config.filterEnabled,
          postWidgetBuilder: config.postWidgetBuilder,
        );

        return buildScreenWithoutTransition(
          context: context,
          state: state,
          child: config.openPageBuilder?.call(
                context,
                timelineScreen,
              ) ??
              Scaffold(
                body: timelineScreen,
              ),
        );
      },
    ),
    GoRoute(
      path: TimelineUserStoryRoutes.timelineView,
      pageBuilder: (context, state) {
        var post =
            config.service.postService.getPost(state.pathParameters['post']!)!;

        var timelinePostWidget = TimelinePostScreen(
          userId: config.userId,
          options: config.optionsBuilder(context),
          service: config.service,
          post: post,
          onPostDelete: () => config.onPostDelete?.call(context, post),
          onUserTap: (user) => config.onUserTap?.call(context, user),
        );

        return buildScreenWithoutTransition(
          context: context,
          state: state,
          child: config.openPageBuilder?.call(
                context,
                timelinePostWidget,
              ) ??
              Scaffold(
                body: timelinePostWidget,
              ),
        );
      },
    ),
  ];
}
