// SPDX-FileCopyrightText: 2023 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause

mixin TimelineUserStoryRoutes {
  static const String timelineHome = '/timeline';
  static const String timelineView = '/timeline-view/:post';
  static String timelineViewPath(String postId) => '/timeline-view/$postId';
  static String timelinepostCreation(String category) =>
      '/timeline-post-creation/$category';

  static const String timelinePostCreation =
      '/timeline-post-creation/:category';
  static String timelinePostOverview = '/timeline-post-overview';
  static String timelineCategorySelection = '/timeline-category-selection';
}
