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
          var timelineFilter =
              Container(); // TODO(anyone): create a filter widget
          var timelineScreen = TimelineScreen(
            userId: configuration.userId,
            onUserTap: (user) => configuration.onUserTap?.call(context, user),
            service: configuration.service,
            options: configuration.optionsBuilder(context),
            onPostTap: (post) async =>
                TimelineUserStoryRoutes.timelineViewPath(post.id),
          );
          return buildScreenWithoutTransition(
            context: context,
            state: state,
            child: configuration.mainPageBuilder?.call(
                  context,
                  timelineFilter,
                  timelineScreen,
                ) ??
                Scaffold(
                  body: timelineScreen,
                ),
          );
        },
      ),
      GoRoute(
        path: TimelineUserStoryRoutes.timelineSelect,
        pageBuilder: (context, state) {
          var timelineSelectionWidget = TimelineSelectionScreen(
            options: configuration.optionsBuilder(context),
            categories: configuration.categoriesBuilder(context),
            onCategorySelected: (category) async => context.push(
              TimelineUserStoryRoutes.timelineCreatePath(category.name),
            ),
          );
          return buildScreenWithoutTransition(
            context: context,
            state: state,
            child: configuration.postSelectionScreenBuilder?.call(
                  context,
                  timelineSelectionWidget,
                ) ??
                Scaffold(
                  body: timelineSelectionWidget,
                ),
          );
        },
      ),
      GoRoute(
        path: TimelineUserStoryRoutes.timelineCreate,
        pageBuilder: (context, state) {
          var timelineCreateWidget = TimelinePostCreationScreen(
            userId: configuration.userId,
            options: configuration.optionsBuilder(context),
            postCategory: state.pathParameters['category'] ?? '',
            service: configuration.service,
            onPostCreated: (post) => context.go(
              TimelineUserStoryRoutes.timelineViewPath(post.id),
            ),
          );
          return buildScreenWithoutTransition(
            context: context,
            state: state,
            child: configuration.postCreationScreenBuilder?.call(
                  context,
                  timelineCreateWidget,
                ) ??
                Scaffold(
                  body: timelineCreateWidget,
                ),
          );
        },
      ),
      GoRoute(
        path: TimelineUserStoryRoutes.timelineView,
        pageBuilder: (context, state) {
          var timelinePostWidget = TimelinePostScreen(
            userId: configuration.userId,
            options: configuration.optionsBuilder(context),
            service: configuration.service,
            post: configuration.service.getPost(state.pathParameters['post']!)!,
            onPostDelete: () => context.pop(),
            onUserTap: (user) => configuration.onUserTap?.call(context, user),
          );
          var category = configuration.categoriesBuilder(context).first;
          return buildScreenWithoutTransition(
            context: context,
            state: state,
            child: configuration.postScreenBuilder?.call(
                  context,
                  timelinePostWidget,
                  category,
                ) ??
                Scaffold(
                  body: timelinePostWidget,
                ),
          );
        },
      ),
    ];
