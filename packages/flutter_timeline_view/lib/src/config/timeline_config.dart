// SPDX-FileCopyrightText: 2024 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause

class TimelineConfig {
  const TimelineConfig({
    this.allowAllDeletion = false,
    this.sortCommentsAscending = true,
    this.sortPostsAscending,
  });

  /// Allow all posts to be deleted instead of
  ///  only the posts of the current user
  final bool allowAllDeletion;

  /// Whether to sort comments ascending or descending
  final bool sortCommentsAscending;

  /// Whether to sort posts ascending or descending
  final bool? sortPostsAscending;
}
