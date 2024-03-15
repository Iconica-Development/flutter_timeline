// SPDX-FileCopyrightText: 2023 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause

import 'package:flutter/material.dart';

@immutable
class TimelineTranslations {
  const TimelineTranslations({
    required this.anonymousUser,
    required this.noPosts,
    required this.noPostsWithFilter,
    required this.title,
    required this.content,
    required this.contentDescription,
    required this.uploadImage,
    required this.uploadImageDescription,
    required this.allowComments,
    required this.allowCommentsDescription,
    required this.checkPost,
    required this.deletePost,
    required this.deleteReaction,
    required this.viewPost,
    required this.likesTitle,
    required this.commentsTitle,
    required this.firstComment,
    required this.writeComment,
    required this.postAt,
    required this.postLoadingError,
    required this.timelineSelectionDescription,
    required this.searchHint,
    required this.postOverview,
    required this.postIn,
    required this.postCreation,
  });

  const TimelineTranslations.empty()
      : anonymousUser = 'Anonymous user',
        noPosts = 'No posts yet',
        noPostsWithFilter = 'No posts with this filter',
        title = 'Title',
        content = 'Content',
        contentDescription = 'What do you want to share?',
        uploadImage = 'Upload image',
        uploadImageDescription = 'Upload an image to your message (optional)',
        allowComments = 'Are people allowed to comment?',
        allowCommentsDescription =
            'Indicate whether people are allowed to respond',
        checkPost = 'Check post overview',
        deletePost = 'Delete post',
        deleteReaction = 'Delete Reaction',
        viewPost = 'View post',
        likesTitle = 'Likes',
        commentsTitle = 'Comments',
        firstComment = 'Be the first to comment',
        writeComment = 'Write your comment here...',
        postAt = 'at',
        postLoadingError = 'Something went wrong while loading the post',
        timelineSelectionDescription = 'Choose a category',
        searchHint = 'Search...',
        postOverview = 'Post Overview',
        postIn = 'Post in',
        postCreation = 'Create Post';

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
  final String deleteReaction;
  final String viewPost;
  final String likesTitle;
  final String commentsTitle;
  final String writeComment;
  final String firstComment;
  final String postLoadingError;

  final String timelineSelectionDescription;

  final String searchHint;

  final String postOverview;
  final String postIn;
  final String postCreation;

  TimelineTranslations copyWith({
    String? noPosts,
    String? noPostsWithFilter,
    String? anonymousUser,
    String? title,
    String? content,
    String? contentDescription,
    String? uploadImage,
    String? uploadImageDescription,
    String? allowComments,
    String? allowCommentsDescription,
    String? checkPost,
    String? postAt,
    String? deletePost,
    String? deleteReaction,
    String? viewPost,
    String? likesTitle,
    String? commentsTitle,
    String? writeComment,
    String? firstComment,
    String? postLoadingError,
    String? timelineSelectionDescription,
    String? searchHint,
    String? postOverview,
    String? postIn,
    String? postCreation,
  }) =>
      TimelineTranslations(
        noPosts: noPosts ?? this.noPosts,
        noPostsWithFilter: noPostsWithFilter ?? this.noPostsWithFilter,
        anonymousUser: anonymousUser ?? this.anonymousUser,
        title: title ?? this.title,
        content: content ?? this.content,
        contentDescription: contentDescription ?? this.contentDescription,
        uploadImage: uploadImage ?? this.uploadImage,
        uploadImageDescription:
            uploadImageDescription ?? this.uploadImageDescription,
        allowComments: allowComments ?? this.allowComments,
        allowCommentsDescription:
            allowCommentsDescription ?? this.allowCommentsDescription,
        checkPost: checkPost ?? this.checkPost,
        postAt: postAt ?? this.postAt,
        deletePost: deletePost ?? this.deletePost,
        deleteReaction: deleteReaction ?? this.deleteReaction,
        viewPost: viewPost ?? this.viewPost,
        likesTitle: likesTitle ?? this.likesTitle,
        commentsTitle: commentsTitle ?? this.commentsTitle,
        writeComment: writeComment ?? this.writeComment,
        firstComment: firstComment ?? this.firstComment,
        postLoadingError: postLoadingError ?? this.postLoadingError,
        timelineSelectionDescription:
            timelineSelectionDescription ?? this.timelineSelectionDescription,
        searchHint: searchHint ?? this.searchHint,
        postOverview: postOverview ?? this.postOverview,
        postIn: postIn ?? this.postIn,
        postCreation: postCreation ?? this.postCreation,
      );
}
