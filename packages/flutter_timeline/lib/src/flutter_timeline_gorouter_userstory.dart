// SPDX-FileCopyrightText: 2023 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause

import 'package:flutter/material.dart';
import 'package:flutter_timeline/flutter_timeline.dart';
import 'package:flutter_timeline/src/go_router.dart';
import 'package:go_router/go_router.dart';

/// Retrieves a list of GoRouter routes for timeline stories.
///
/// This function retrieves a list of GoRouter routes for displaying timeline
/// stories. It takes an optional [TimelineUserStoryConfiguration] as parameter.
/// If no configuration is provided, default values will be used.
List<GoRoute> getTimelineStoryRoutes({
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

        var button = FloatingActionButton(
          onPressed: () async => context.go(
            TimelineUserStoryRoutes.timelinePostCreation,
          ),
          child: const Icon(Icons.add),
        );

        return buildScreenWithoutTransition(
          context: context,
          state: state,
          child: config.homeOpenPageBuilder
                  ?.call(context, timelineScreen, button) ??
              Scaffold(
                appBar: AppBar(),
                body: timelineScreen,
                floatingActionButton: button,
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

        var backButton = IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => context.go(TimelineUserStoryRoutes.timelineHome),
        );

        return buildScreenWithoutTransition(
          context: context,
          state: state,
          child: config.postViewOpenPageBuilder
                  ?.call(context, timelinePostWidget, backButton) ??
              Scaffold(
                appBar: AppBar(
                  leading: backButton,
                ),
                body: timelinePostWidget,
              ),
        );
      },
    ),
    GoRoute(
      path: TimelineUserStoryRoutes.timelinePostCreation,
      pageBuilder: (context, state) {
        var timelinePostCreationWidget = TimelinePostCreationScreen(
          userId: config.userId,
          options: config.optionsBuilder(context),
          service: config.service,
          onPostCreated: (post) async {
            var newPost = await config.service.postService.createPost(post);
            if (context.mounted) {
              if (config.afterPostCreationGoHome) {
                context.go(TimelineUserStoryRoutes.timelineHome);
              } else {
                await context
                    .push(TimelineUserStoryRoutes.timelineViewPath(newPost.id));
              }
            }
          },
          onPostOverview: (post) async => context.push(
            TimelineUserStoryRoutes.timelinePostOverview,
            extra: post,
          ),
          enablePostOverviewScreen: config.enablePostOverviewScreen,
        );

        var backButton = IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => context.go(TimelineUserStoryRoutes.timelineHome),
        );

        return buildScreenWithoutTransition(
          context: context,
          state: state,
          child: config.postCreationOpenPageBuilder
                  ?.call(context, timelinePostCreationWidget, backButton) ??
              Scaffold(
                appBar: AppBar(
                  title: Text(
                    config.optionsBuilder(context).translations.postCreation,
                  ),
                  leading: backButton,
                ),
                body: timelinePostCreationWidget,
              ),
        );
      },
    ),
    GoRoute(
      path: TimelineUserStoryRoutes.timelinePostOverview,
      pageBuilder: (context, state) {
        var post = state.extra! as TimelinePost;

        var timelinePostOverviewWidget = TimelinePostOverviewScreen(
          options: config.optionsBuilder(context),
          service: config.service,
          timelinePost: post,
          onPostSubmit: (post) async {
            await config.service.postService.createPost(post);
            if (context.mounted) {
              context.go(TimelineUserStoryRoutes.timelineHome);
            }
          },
        );

        return buildScreenWithoutTransition(
          context: context,
          state: state,
          child: config.postOverviewOpenPageBuilder?.call(
                context,
                timelinePostOverviewWidget,
              ) ??
              timelinePostOverviewWidget,
        );
      },
    ),
  ];
}
