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

  var timelineScreen = TimelineScreen(
    userId: config.getUserId?.call(context) ?? config.userId,
    onUserTap: (user) => config.onUserTap?.call(context, user),
    service: config.service,
    options: config.optionsBuilder(context),
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
    filterEnabled: config.filterEnabled,
    postWidgetBuilder: config.postWidgetBuilder,
  );

  var button = FloatingActionButton(
    backgroundColor: config
            .optionsBuilder(context)
            .theme
            .postCreationFloatingActionButtonColor ??
        const Color(0xff71C6D1),
    onPressed: () async => Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => _postCategorySelectionScreen(
          configuration: config,
          context: context,
        ),
      ),
    ),
    shape: const CircleBorder(),
    child: const Icon(
      Icons.add,
      color: Colors.white,
      size: 30,
    ),
  );

  return config.homeOpenPageBuilder?.call(context, timelineScreen, button) ??
      Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xff212121),
          title: Text(
            config.optionsBuilder(context).translations.timeLineScreenTitle!,
            style: const TextStyle(
              color: Color(0xff71C6D1),
              fontSize: 24,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        body: timelineScreen,
        floatingActionButton: button,
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

  var timelinePostScreen = TimelinePostScreen(
    userId: config.getUserId?.call(context) ?? config.userId,
    options: config.optionsBuilder(context),
    service: config.service,
    post: post,
    onPostDelete: () async =>
        config.onPostDelete?.call(context, post) ??
        await config.service.postService.deletePost(post),
    onUserTap: (user) => config.onUserTap?.call(context, user),
  );

  var category = config
      .optionsBuilder(context)
      .categoriesOptions
      .categoriesBuilder
      ?.call(context)
      .firstWhere((element) => element.key == post.category);

  var backButton = IconButton(
    color: Colors.white,
    icon: const Icon(Icons.arrow_back_ios),
    onPressed: () => Navigator.of(context).pop(),
  );

  return config.postViewOpenPageBuilder
          ?.call(context, timelinePostScreen, backButton, post, category) ??
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
        body: timelinePostScreen,
      );
}

/// A widget function that creates a post creation screen route.
///
/// This function creates a route for displaying a post creation screen.
/// It takes a [BuildContext] and an optional [TimelineUserStoryConfiguration]
/// as parameters. If no configuration is provided, default values will be used.
Widget _postCreationScreenRoute({
  required BuildContext context,
  required TimelineCategory category,
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

  var timelinePostCreationScreen = TimelinePostCreationScreen(
    userId: config.getUserId?.call(context) ?? config.userId,
    options: config.optionsBuilder(context),
    service: config.service,
    onPostCreated: (post) async {
      var newPost = await config.service.postService.createPost(post);
      if (context.mounted) {
        if (config.afterPostCreationGoHome) {
          await Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => _timelineScreenRoute(
                configuration: config,
                context: context,
              ),
            ),
          );
        } else {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => _postOverviewScreenRoute(
                configuration: config,
                context: context,
                post: newPost,
              ),
            ),
          );
        }
      }
    },
    onPostOverview: (post) async => Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => _postOverviewScreenRoute(
          configuration: config,
          context: context,
          post: post,
        ),
      ),
    ),
    enablePostOverviewScreen: config.enablePostOverviewScreen,
    postCategory: category.title,
  );

  var backButton = IconButton(
    icon: const Icon(
      Icons.arrow_back_ios,
      color: Colors.white,
    ),
    onPressed: () => Navigator.of(context).pop(),
  );

  return config.postCreationOpenPageBuilder
          ?.call(context, timelinePostCreationScreen, backButton) ??
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
        body: timelinePostCreationScreen,
      );
}

/// A widget function that creates a post overview screen route.
///
/// This function creates a route for displaying a post overview screen.
/// It takes a [BuildContext], a [TimelinePost], and an optional
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

  var timelinePostOverviewWidget = TimelinePostOverviewScreen(
    options: config.optionsBuilder(context),
    service: config.service,
    timelinePost: post,
    onPostSubmit: (post) async {
      await config.service.postService.createPost(post);
      if (context.mounted) {
        await Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) =>
                _timelineScreenRoute(configuration: config, context: context),
          ),
          (route) => false,
        );
      }
    },
    isOverviewScreen: true,
  );

  var backButton = IconButton(
    icon: const Icon(
      Icons.arrow_back_ios,
      color: Colors.white,
    ),
    onPressed: () async => Navigator.of(context).pop(),
  );

  return config.postOverviewOpenPageBuilder?.call(
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
      );
}

Widget _postCategorySelectionScreen({
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

  var timelineSelectionScreen = TimelineSelectionScreen(
    options: config.optionsBuilder(context),
    categories: config
        .optionsBuilder(context)
        .categoriesOptions
        .categoriesBuilder!(context),
    onCategorySelected: (category) async {
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => _postCreationScreenRoute(
            configuration: config,
            context: context,
            category: category,
          ),
        ),
      );
    },
  );

  var backButton = IconButton(
    color: Colors.white,
    icon: const Icon(Icons.arrow_back_ios),
    onPressed: () async {
      Navigator.of(context).pop();
    },
  );

  return config.categorySelectionOpenPageBuilder
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
      );
}
