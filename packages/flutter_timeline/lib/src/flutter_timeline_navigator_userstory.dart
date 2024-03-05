// SPDX-FileCopyrightText: 2024 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause

import 'package:flutter/material.dart';
import 'package:flutter_timeline/flutter_timeline.dart';

/// A widget function that creates a timeline navigator for user stories.
///
/// This function creates a navigator for displaying user stories on a timeline.
/// It takes a [BuildContext] and an optional [TimelineUserStoryConfiguration]
/// as parameters. If no configuration is provided, default values will be used.
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

/// A widget function that creates a timeline screen route.
///
/// This function creates a route for displaying a timeline screen. It takes
/// a [BuildContext] and an optional [TimelineUserStoryConfiguration] as
/// parameters. If no configuration is provided, default values will be used.
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

  return Scaffold(
    appBar: AppBar(),
    floatingActionButton: FloatingActionButton(
      onPressed: () async => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => _postCreationScreenRoute(
            configuration: config,
            context: context,
          ),
        ),
      ),
      child: const Icon(Icons.add),
    ),
    body: TimelineScreen(
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
    ),
  );
}

/// A widget function that creates a post detail screen route.
///
/// This function creates a route for displaying a post detail screen. It takes
/// a [BuildContext], a [TimelinePost], and an optional
/// [TimelineUserStoryConfiguration] as parameters. If no configuration is
/// provided, default values will be used.
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

/// A widget function that creates a post creation screen route.
///
/// This function creates a route for displaying a post creation screen. It takes
/// a [BuildContext] and an optional [TimelineUserStoryConfiguration] as
/// parameters. If no configuration is provided, default values will be used.
Widget _postCreationScreenRoute({
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

  return Scaffold(
    appBar: AppBar(
      title: Text(
        config.optionsBuilder(context).translations.postCreation,
      ),
    ),
    body: TimelinePostCreationScreen(
      userId: config.userId,
      service: config.service,
      options: config.optionsBuilder(context),
      onPostCreated: (post) async {
        await config.service.postService.createPost(post);
        if (context.mounted) {
          await Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  _timelineScreenRoute(configuration: config, context: context),
            ),
          );
        }
      },
      onPostOverview: (post) async {
        await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => _postOverviewScreenRoute(
              configuration: config,
              context: context,
              post: post,
            ),
          ),
        );
      },
      enablePostOverviewScreen: config.enablePostOverviewScreen,
    ),
  );
}

/// A widget function that creates a post overview screen route.
///
/// This function creates a route for displaying a post overview screen. It takes
/// a [BuildContext], a [TimelinePost], and an optional
/// [TimelineUserStoryConfiguration] as parameters. If no configuration is
/// provided, default values will be used.
Widget _postOverviewScreenRoute({
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

  return TimelinePostOverviewScreen(
    timelinePost: post,
    options: config.optionsBuilder(context),
    service: config.service,
    onPostSubmit: (post) async {
      await config.service.postService.createPost(post);
      if (context.mounted) {
        await Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>
                _timelineScreenRoute(configuration: config, context: context),
          ),
        );
      }
    },
  );
}
