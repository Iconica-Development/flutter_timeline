import 'package:flutter/material.dart';
import 'package:flutter_timeline/flutter_timeline.dart';
import 'package:flutter_timeline/src/go_router.dart';
import 'package:go_router/go_router.dart';

mixin TimelineUserStoryRoutes {
  static const String timelineHome = '/timeline';
  static const String timelineCreate = '/timeline-create/:category';
  static String timelineCreatePath(String category) =>
      '/timeline-create/$category';
  static const String timelineSelect = '/timeline-select';
  static const String timelineView = '/timeline-view/:post';
  static String timelineViewPath(String postId) => '/timeline-view/$postId';
}

class TimelineUserStoryConfiguration {
  const TimelineUserStoryConfiguration({
    required this.optionsBuilder,
    required this.userId,
    required this.service,
    required this.userService,
    this.mainPageBuilder,
    this.postScreenBuilder,
    this.postCreationScreenBuilder,
    this.postSelectionScreenBuilder,
    this.onUserTap,
  });

  final String userId;

  final Function(String userId)? onUserTap;

  final Widget Function(Widget filterBar, Widget child)? mainPageBuilder;

  final Widget Function(Widget child)? postScreenBuilder;

  final Widget Function(Widget child)? postCreationScreenBuilder;

  final Widget Function(Widget child)? postSelectionScreenBuilder;

  final TimelineService service;

  final TimelineUserService userService;

  final TimelineOptions Function(BuildContext context) optionsBuilder;
}

List<GoRoute> getTimelineStoryRoutes(
  TimelineUserStoryConfiguration configuration,
) =>
    <GoRoute>[
      GoRoute(
        path: TimelineUserStoryRoutes.timelineHome,
        pageBuilder: (context, state) {
          var timelineScreen = TimelineScreen(
            userId: configuration.userId,
            onUserTap: configuration.onUserTap,
            service: configuration.service,
            options: configuration.optionsBuilder(context),
            onPostTap: (post) async =>
                TimelineUserStoryRoutes.timelineViewPath(post.id),
            timelineCategoryFilter: 'news',
          );
          return buildScreenWithoutTransition(
            context: context,
            state: state,
            child: configuration.mainPageBuilder?.call(
                  Container(), // TODO(anyone): create a selection widget
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
          var timelineSelectionWidget =
              Container(); // TODO(anyone): create timeline selection screen
          return buildScreenWithoutTransition(
            context: context,
            state: state,
            child: configuration.postSelectionScreenBuilder?.call(
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
            child: configuration.postCreationScreenBuilder
                    ?.call(timelineCreateWidget) ??
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
            userService: configuration.userService,
            post: configuration.service.getPost(state.pathParameters['post']!)!,
            onPostDelete: () => context.go(
              TimelineUserStoryRoutes.timelineHome,
            ),
            onUserTap: configuration.onUserTap,
          );
          return buildScreenWithoutTransition(
            context: context,
            state: state,
            child: configuration.postScreenBuilder?.call(
                  timelinePostWidget,
                ) ??
                Scaffold(
                  body: timelinePostWidget,
                ),
          );
        },
      ),
    ];
