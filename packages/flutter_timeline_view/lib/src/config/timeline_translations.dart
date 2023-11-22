// SPDX-FileCopyrightText: 2023 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause

import 'package:flutter/material.dart';

@immutable
class TimelineTranslations {
  const TimelineTranslations({
    this.anonymousUser = 'Anonymous user',
    this.noPosts = 'No posts yet',
    this.noPostsWithFilter = 'No posts with this filter',
    this.title = 'Title',
    this.content = 'Content',
    this.contentDescription = 'What do you want to share?',
    this.uploadImage = 'Upload image',
    this.uploadImageDescription = 'Upload an image to your message (optional)',
    this.allowComments = 'Are people allowed to comment?',
    this.allowCommentsDescription =
        'Indicate whether people are allowed to respond',
    this.checkPost = 'Check post overview',
    this.deletePost = 'Delete post',
    this.viewPost = 'View post',
    this.likesTitle = 'Likes',
    this.commentsTitle = 'Comments',
    this.firstComment = 'Be the first to comment',
    this.writeComment = 'Write your comment here...',
    this.postAt = 'at',
    this.postLoadingError = 'Something went wrong while loading the post',
  });

  final String noPosts;
  final String noPostsWithFilter;
  final String anonymousUser;

  final String title;
  final String content;
  final String contentDescription;
  final String uploadImage;
  final String uploadImageDescription;
  final String allowComments;
  final String allowCommentsDescription;
  final String checkPost;
  final String postAt;

  final String deletePost;
  final String viewPost;
  final String likesTitle;
  final String commentsTitle;
  final String writeComment;
  final String firstComment;
  final String postLoadingError;
}
