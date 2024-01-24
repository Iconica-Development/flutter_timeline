// SPDX-FileCopyrightText: 2023 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause

import 'package:flutter/material.dart';
import 'package:flutter_timeline/src/go_router.dart';
import 'package:flutter_timeline/src/models/timeline_configuration.dart';
import 'package:flutter_timeline/src/routes.dart';
import 'package:flutter_timeline_view/flutter_timeline_view.dart';
import 'package:go_router/go_router.dart';

List<GoRoute> getTimelineStoryRoutes(
  TimelineUserStoryConfiguration configuration,
) =>
    <GoRoute>[
      GoRoute(
        path: TimelineUserStoryRoutes.timelineHome,
        pageBuilder: (context, state) {
          var timelineScreen = TimelineScreen(
            userId: configuration.userId,
            onUserTap: (user) => configuration.onUserTap?.call(context, user),
            service: configuration.service,
            options: configuration.optionsBuilder(context),
            onPostTap: (post) async =>
                configuration.onPostTap?.call(context, post) ??
                await context.push(
                  TimelineUserStoryRoutes.timelineViewPath(post.id),
                ),
          );

          return buildScreenWithoutTransition(
            context: context,
            state: state,
            child: configuration.openPageBuilder?.call(
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
              configuration.service.getPost(state.pathParameters['post']!)!;

          var timelinePostWidget = TimelinePostScreen(
            userId: configuration.userId,
            options: configuration.optionsBuilder(context),
            service: configuration.service,
            post: post,
            onPostDelete: () => configuration.onPostDelete?.call(context, post),
            onUserTap: (user) => configuration.onUserTap?.call(context, user),
          );

          return buildScreenWithoutTransition(
            context: context,
            state: state,
            child: configuration.openPageBuilder?.call(
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
