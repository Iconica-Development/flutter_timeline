import 'package:flutter/material.dart';

@immutable
class TimelineTextStyles {
  /// Options to update all the texts in the timeline view
  /// with different textstyles
  const TimelineTextStyles({
    this.viewPostStyle,
    this.listPostTitleStyle,
    this.listPostCreatorTitleStyle,
    this.listCreatorNameStyle,
    this.listPostLikeTitleAndAmount,
    this.deletePostStyle,
    this.categorySelectionDescriptionStyle,
    this.categorySelectionTitleStyle,
    this.noPostsStyle,
    this.errorTextStyle,
    this.postCreatorTitleStyle,
    this.postCreatorNameStyle,
    this.postTitleStyle,
    this.postLikeTitleAndAmount,
    this.postCreatedAtStyle,
  });

  /// The TextStyle for the text indicating that you can view a post
  final TextStyle? viewPostStyle;

  /// The TextStyle for the creatorname at the top of the card
  /// when it is in the list
  final TextStyle? listPostCreatorTitleStyle;

  /// The TextStyle for the post title when it is in the list
  final TextStyle? listPostTitleStyle;

  /// The TextStyle for the creatorname at the bottom of the card
  /// when it is in the list
  final TextStyle? listCreatorNameStyle;

  /// The TextStyle for the amount of like and name of the likes at
  /// the bottom of the card when it is in the list
  final TextStyle? listPostLikeTitleAndAmount;

  /// The TextStyle for the deletion text that shows in the popupmenu
  final TextStyle? deletePostStyle;

  /// The TextStyle for the category explainer on the selection page
  final TextStyle? categorySelectionDescriptionStyle;

  /// The TextStyle for the category items in the list on the selection page
  final TextStyle? categorySelectionTitleStyle;

  /// The TextStyle for the text when there are no posts
  final TextStyle? noPostsStyle;

  /// The TextStyle for all error texts
  final TextStyle? errorTextStyle;

  /// The TextStyle for the creatorname at the top of the post page
  final TextStyle? postCreatorTitleStyle;

  /// The TextStyle for the creatorname at the bottom of the post page
  final TextStyle? postCreatorNameStyle;

  /// The TextStyle for the title of the post on the post page
  final TextStyle? postTitleStyle;

  /// The TextStyle for the amount of likes and name of the likes
  /// on the post page
  final TextStyle? postLikeTitleAndAmount;

  /// The TextStyle for the creation time of the post
  final TextStyle? postCreatedAtStyle;
}
