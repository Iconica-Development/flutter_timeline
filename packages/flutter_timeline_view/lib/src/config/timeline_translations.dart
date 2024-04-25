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
    this.deleteReaction = 'Delete Reaction',
    this.viewPost = 'View post',
    this.likesTitle = 'Likes',
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

  final String? noPosts;
  final String? noPostsWithFilter;
  final String? anonymousUser;

  final String? title;
  final String? content;
  final String? contentDescription;
  final String? uploadImage;
  final String? uploadImageDescription;
  final String? allowComments;
  final String? allowCommentsDescription;
  final String? checkPost;
  final String? postAt;

  final String? titleHintText;
  final String? contentHintText;

  final String? deletePost;
  final String? deleteReaction;
  final String? viewPost;
  final String? likesTitle;
  final String? commentsTitle;
  final String? commentsTitleOnPost;
  final String? writeComment;
  final String? firstComment;
  final String? postLoadingError;

  final String? timelineSelectionDescription;

  final String? searchHint;

  final String? postOverview;
  final String? postIn;
  final String? postCreation;

  final String? yes;
  final String? no;
  final String? timeLineScreenTitle;

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
