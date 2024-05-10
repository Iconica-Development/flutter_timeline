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
        var service = config.serviceBuilder?.call(context) ?? config.service;
        var timelineScreen = TimelineScreen(
          userId: config.getUserId?.call(context) ?? config.userId,
          onUserTap: (user) => config.onUserTap?.call(context, user),
          service: service,
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
          backgroundColor: const Color(0xff71C6D1),
          onPressed: () async => context.push(
            TimelineUserStoryRoutes.timelineCategorySelection,
          ),
          shape: const CircleBorder(),
          child: const Icon(
            Icons.add,
            color: Colors.white,
            size: 30,
          ),
        );

        return buildScreenWithoutTransition(
          context: context,
          state: state,
          child: config.homeOpenPageBuilder
                  ?.call(context, timelineScreen, button) ??
              Scaffold(
                appBar: AppBar(
                  backgroundColor: const Color(0xff212121),
                  title: Text(
                    config
                        .optionsBuilder(context)
                        .translations
                        .timeLineScreenTitle!,
                    style: const TextStyle(
                      color: Color(0xff71C6D1),
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                body: timelineScreen,
                floatingActionButton: button,
              ),
        );
      },
    ),
    GoRoute(
      path: TimelineUserStoryRoutes.timelineCategorySelection,
      pageBuilder: (context, state) {
        var timelineSelectionScreen = TimelineSelectionScreen(
          options: config.optionsBuilder(context),
          categories: config
              .optionsBuilder(context)
              .categoriesOptions
              .categoriesBuilder!(context),
          onCategorySelected: (category) async {
            await context.push(
              TimelineUserStoryRoutes.timelinepostCreation(category.title),
            );
          },
        );

        var backButton = IconButton(
          color: Colors.white,
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => context.go(TimelineUserStoryRoutes.timelineHome),
        );

        return buildScreenWithoutTransition(
          context: context,
          state: state,
          child: config.categorySelectionOpenPageBuilder
                  ?.call(context, timelineSelectionScreen) ??
              Scaffold(
                appBar: AppBar(
                  leading: backButton,
                  backgroundColor: const Color(0xff212121),
                  title: Text(
                    config.optionsBuilder(context).translations.postCreation!,
                    style: const TextStyle(
                      color: Color(0xff71C6D1),
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                body: timelineSelectionScreen,
              ),
        );
      },
    ),
    GoRoute(
      path: TimelineUserStoryRoutes.timelineView,
      pageBuilder: (context, state) {
        var service = config.serviceBuilder?.call(context) ?? config.service;
        var post = service.postService.getPost(state.pathParameters['post']!);

        var timelinePostWidget = TimelinePostScreen(
          userId: config.getUserId?.call(context) ?? config.userId,
          options: config.optionsBuilder(context),
          service: service,
          post: post!,
          onPostDelete: () => config.onPostDelete?.call(context, post),
          onUserTap: (user) => config.onUserTap?.call(context, user),
        );

        var backButton = IconButton(
          color: Colors.white,
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
                  backgroundColor: const Color(0xff212121),
                  title: Text(
                    post.category ?? 'Category',
                    style: const TextStyle(
                      color: Color(0xff71C6D1),
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                body: timelinePostWidget,
              ),
        );
      },
    ),
    GoRoute(
      path: TimelineUserStoryRoutes.timelinePostCreation,
      pageBuilder: (context, state) {
        var category = state.pathParameters['category'];
        var service = config.serviceBuilder?.call(context) ?? config.service;
        var timelinePostCreationWidget = TimelinePostCreationScreen(
          userId: config.getUserId?.call(context) ?? config.userId,
          options: config.optionsBuilder(context),
          service: service,
          onPostCreated: (post) async {
            var newPost = await service.postService.createPost(post);
            if (!context.mounted) return;
            if (config.afterPostCreationGoHome) {
              context.go(TimelineUserStoryRoutes.timelineHome);
            } else {
              await context
                  .push(TimelineUserStoryRoutes.timelineViewPath(newPost.id));
            }
          },
          onPostOverview: (post) async => context.push(
            TimelineUserStoryRoutes.timelinePostOverview,
            extra: post,
          ),
          enablePostOverviewScreen: config.enablePostOverviewScreen,
          postCategory: category,
        );

        var backButton = IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          onPressed: () =>
              context.go(TimelineUserStoryRoutes.timelineCategorySelection),
        );

        return buildScreenWithoutTransition(
          context: context,
          state: state,
          child: config.postCreationOpenPageBuilder
                  ?.call(context, timelinePostCreationWidget, backButton) ??
              Scaffold(
                appBar: AppBar(
                  backgroundColor: const Color(0xff212121),
                  leading: backButton,
                  title: Text(
                    config.optionsBuilder(context).translations.postCreation!,
                    style: const TextStyle(
                      color: Color(0xff71C6D1),
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
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
        var service = config.serviceBuilder?.call(context) ?? config.service;
        var timelinePostOverviewWidget = TimelinePostOverviewScreen(
          options: config.optionsBuilder(context),
          service: service,
          timelinePost: post,
          onPostSubmit: (post) async {
            await service.postService.createPost(post);
            if (!context.mounted) return;
            context.go(TimelineUserStoryRoutes.timelineHome);
          },
        );
        var backButton = IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          onPressed: () async => context.pop(),
        );

        return buildScreenWithoutTransition(
          context: context,
          state: state,
          child: config.postOverviewOpenPageBuilder?.call(
                context,
                timelinePostOverviewWidget,
              ) ??
              Scaffold(
                appBar: AppBar(
                  leading: backButton,
                  backgroundColor: const Color(0xff212121),
                  title: Text(
                    config.optionsBuilder(context).translations.postOverview!,
                    style: const TextStyle(
                      color: Color(0xff71C6D1),
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                body: timelinePostOverviewWidget,
              ),
        );
      },
    ),
  ];
}
