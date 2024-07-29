// SPDX-FileCopyrightText: 2023 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause

import 'package:flutter/material.dart';

@immutable

/// Class that holds all the translations for the timeline component view and
///  the corresponding userstory
class TimelineTranslations {
  /// TimelineTranslations constructor where everything is required use this
  /// if you want to be sure to have all translations specified
  /// If you just want the default values use the empty constructor
  /// and optionally override the values with the copyWith method
  const TimelineTranslations({
    required this.anonymousUser,
    required this.noPosts,
    required this.noPostsWithFilter,
    required this.title,
    required this.titleHintText,
    required this.content,
    required this.contentHintText,
    required this.contentDescription,
    required this.uploadImage,
    required this.uploadImageDescription,
    required this.allowComments,
    required this.allowCommentsDescription,
    required this.commentsTitleOnPost,
    required this.checkPost,
    required this.postAt,
    required this.deletePost,
    required this.deleteReaction,
    required this.deleteConfirmationMessage,
    required this.deleteConfirmationTitle,
    required this.deleteCancelButton,
    required this.deleteButton,
    required this.viewPost,
    required this.likesTitle,
    required this.commentsTitle,
    required this.firstComment,
    required this.writeComment,
    required this.postLoadingError,
    required this.timelineSelectionDescription,
    required this.searchHint,
    required this.postOverview,
    required this.postIn,
    required this.postCreation,
    required this.yes,
    required this.no,
    required this.timeLineScreenTitle,
  });

  /// Default translations for the timeline component view
  const TimelineTranslations.empty({
    this.anonymousUser = 'Anonymous user',
    this.noPosts = 'No posts yet',
    this.noPostsWithFilter = 'No posts with this filter',
    this.title = 'Title',
    this.titleHintText = 'Title...',
    this.content = 'Content',
    this.contentHintText = 'Content...',
    this.contentDescription = 'What do you want to share?',
    this.uploadImage = 'Upload image',
    this.uploadImageDescription = 'Upload an image to your message (optional)',
    this.allowComments = 'Are people allowed to comment?',
    this.allowCommentsDescription =
        'Indicate whether people are allowed to respond',
    this.commentsTitleOnPost = 'Comments',
    this.checkPost = 'Check post overview',
    this.deletePost = 'Delete post',
    this.deleteConfirmationTitle = 'Delete Post',
    this.deleteConfirmationMessage =
        'Are you sure you want to delete this post?',
    this.deleteButton = 'Delete',
    this.deleteCancelButton = 'Cancel',
    this.deleteReaction = 'Delete Reaction',
    this.viewPost = 'View post',
    this.likesTitle = 'likes',
    this.commentsTitle = 'Are people allowed to comment?',
    this.firstComment = 'Be the first to comment',
    this.writeComment = 'Write your comment here...',
    this.postAt = 'at',
    this.postLoadingError = 'Something went wrong while loading the post',
    this.timelineSelectionDescription = 'Choose a category',
    this.searchHint = 'Search...',
    this.postOverview = 'Post Overview',
    this.postIn = 'Post in',
    this.postCreation = 'add post',
    this.yes = 'Yes',
    this.no = 'No',
    this.timeLineScreenTitle = 'iconinstagram',
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

  final String titleHintText;
  final String contentHintText;

  final String deletePost;
  final String deleteConfirmationTitle;
  final String deleteConfirmationMessage;
  final String deleteButton;
  final String deleteCancelButton;

  final String deleteReaction;
  final String viewPost;
  final String likesTitle;
  final String commentsTitle;
  final String commentsTitleOnPost;
  final String writeComment;
  final String firstComment;
  final String postLoadingError;

  final String timelineSelectionDescription;

  final String searchHint;

  final String postOverview;
  final String postIn;
  final String postCreation;

  final String yes;
  final String no;
  final String timeLineScreenTitle;

  /// Method to override the default values of the translations
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
    String? commentsTitleOnPost,
    String? checkPost,
    String? postAt,
    String? deletePost,
    String? deleteConfirmationTitle,
    String? deleteConfirmationMessage,
    String? deleteButton,
    String? deleteCancelButton,
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
    String? titleHintText,
    String? contentHintText,
    String? yes,
    String? no,
    String? timeLineScreenTitle,
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
        commentsTitleOnPost: commentsTitleOnPost ?? this.commentsTitleOnPost,
        checkPost: checkPost ?? this.checkPost,
        postAt: postAt ?? this.postAt,
        deletePost: deletePost ?? this.deletePost,
        deleteConfirmationTitle:
            deleteConfirmationTitle ?? this.deleteConfirmationTitle,
        deleteConfirmationMessage:
            deleteConfirmationMessage ?? this.deleteConfirmationMessage,
        deleteButton: deleteButton ?? this.deleteButton,
        deleteCancelButton: deleteCancelButton ?? this.deleteCancelButton,
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
        titleHintText: titleHintText ?? this.titleHintText,
        contentHintText: contentHintText ?? this.contentHintText,
        yes: yes ?? this.yes,
        no: no ?? this.no,
        timeLineScreenTitle: timeLineScreenTitle ?? this.timeLineScreenTitle,
      );
}
