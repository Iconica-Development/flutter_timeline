import 'package:flutter/material.dart';
import 'package:flutter_timeline/flutter_timeline.dart';
import 'package:flutter_timeline/src/go_router.dart';
import 'package:go_router/go_router.dart';

mixin TimelineUserStoryRoutes {
  static const String timelineHome = '/timeline';
  static String timelineCreate(String category) => '/timeline-create/$category';
  static const String timelineSelect = '/timeline-select';
  static String timelineView(String postId) => '/timeline-view/$postId';
}

class TimelineUserStoryConfiguration {
  const TimelineUserStoryConfiguration({
    required this.optionsBuilder,
    required this.userId,
    required this.service,
    this.pageBuilder,
    this.onUserTap,
    this.timelinePostHeight,
  });

  final String userId;

  final double? timelinePostHeight;
  final Function(String userId)? onUserTap;

  final Widget Function(Widget child)? pageBuilder;

  final TimelineService service;

  final TimelineOptions Function(BuildContext context)
      optionsBuilder; // New callback
}

List<GoRoute> getTimelineStoryRoutes(
  TimelineUserStoryConfiguration configuration,
) =>
    <GoRoute>[
      GoRoute(
        path: TimelineUserStoryRoutes.timelineHome,
        pageBuilder: (context, state) => buildScreenWithoutTransition(
          context: context,
          state: state,
          child: Scaffold(
            body: TimelineScreen(
              userId: configuration.userId,
              onUserTap: configuration.onUserTap,
              service: configuration.service,
              options: configuration.optionsBuilder(context),
              timelinePostHeight: configuration.timelinePostHeight,
              onPostTap: (_) async => context.push('/timeline-view/1'),
              timelineCategoryFilter: 'category',
            ),
          ),
        ),
      ),

      /// Here come the other timeline screens that all use the same configuration
    ];
