// SPDX-FileCopyrightText: 2024 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause

class TimelinePostCreationConfig {
  const TimelinePostCreationConfig({
    this.requireImageForPost = false,
    this.minTitleLength,
    this.maxTitleLength,
    this.minContentLength,
    this.maxContentLength,
  });

  /// Require image for post
  final bool requireImageForPost;

  /// Minimum length of the title
  final int? minTitleLength;

  /// Maximum length of the title
  final int? maxTitleLength;

  /// Minimum length of the post content
  final int? minContentLength;

  /// Maximum length of the post content
  final int? maxContentLength;
}
