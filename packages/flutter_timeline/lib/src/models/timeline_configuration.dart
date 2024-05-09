// SPDX-FileCopyrightText: 2023 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause

import 'package:flutter/material.dart';
import 'package:flutter_timeline_interface/flutter_timeline_interface.dart';
import 'package:flutter_timeline_view/flutter_timeline_view.dart';

/// Configuration class for defining user-specific settings and callbacks for a
/// timeline user story.
///
/// This class holds various parameters to customize the behavior and appearance
/// of a user story timeline.
@immutable
class TimelineUserStoryConfiguration {
  /// Constructs a [TimelineUserStoryConfiguration] with the specified
  /// parameters.
  ///
  /// [service] is the TimelineService responsible for fetching user story data.
  ///
  /// [optionsBuilder] is a function that builds TimelineOptions based on the
  /// given [BuildContext].
  ///
  /// [userId] is the ID of the user associated with this user story
  /// configuration. Default is 'test_user'.
  ///
  /// [openPageBuilder] is a function that defines the behavior when a page
  /// needs to be opened. This function should accept a [BuildContext] and a
  /// child widget.
  ///
  /// [onPostTap] is a callback function invoked when a timeline post is
  /// tapped. It should accept a [BuildContext] and the tapped post.
  ///
  /// [onUserTap] is a callback function invoked when the user's profile is
  /// tapped. It should accept a [BuildContext] and the user ID of the tapped
  /// user.
  ///
  /// [onPostDelete] is a callback function invoked when a post deletion is
  /// requested. It should accept a [BuildContext] and the post widget. This
  /// function can return a widget to be displayed after the post is deleted.
  ///
  /// [filterEnabled] determines whether filtering functionality is enabled for
  /// this user story timeline. Default is false.
  ///
  /// [postWidgetBuilder] is a function that builds a widget for a timeline
  /// post. It should accept a [TimelinePost] and return a widget representing
  /// that post.
  const TimelineUserStoryConfiguration({
    required this.service,
    required this.optionsBuilder,
    this.serviceBuilder,
    this.userId = 'test_user',
    this.homeOpenPageBuilder,
    this.postCreationOpenPageBuilder,
    this.postViewOpenPageBuilder,
    this.postOverviewOpenPageBuilder,
    this.onPostTap,
    this.onUserTap,
    this.onPostDelete,
    this.filterEnabled = false,
    this.postWidgetBuilder,
    this.afterPostCreationGoHome = false,
    this.enablePostOverviewScreen = true,
    this.categorySelectionOpenPageBuilder,
  });

  /// The ID of the user associated with this user story configuration.
  final String userId;

  /// The TimelineService responsible for fetching user story data.
  final TimelineService service;

  /// A function to get the timeline service only when needed and with a context
  final TimelineService Function(BuildContext context)? serviceBuilder;

  /// A function that builds TimelineOptions based on the given BuildContext.
  final TimelineOptions Function(BuildContext context) optionsBuilder;

  /// Open page builder function for the home page. This function accepts
  /// a [BuildContext], a child widget, and a FloatingActionButton which can
  /// route to the post creation page.

  final Function(
    BuildContext context,
    Widget child,
    FloatingActionButton? button,
  )? homeOpenPageBuilder;

  /// Open page builder function for the post creation page. This function
  /// accepts a [BuildContext], a child widget, and an IconButton which can
  /// route to the home page.

  final Function(
    BuildContext context,
    Widget child,
    IconButton? button,
  )? postCreationOpenPageBuilder;

  /// Open page builder function for the post view page. This function accepts
  /// a [BuildContext], a child widget, and an IconButton which can route to the
  /// home page.

  final Function(
    BuildContext context,
    Widget child,
    IconButton? button,
  )? postViewOpenPageBuilder;

  /// Open page builder function for the post overview page. This function
  /// accepts a [BuildContext], a child widget, and an IconButton which can
  /// route to the home page.

  final Function(
    BuildContext context,
    Widget child,
  )? postOverviewOpenPageBuilder;

  /// A callback function invoked when a timeline post is tapped.
  final Function(BuildContext context, TimelinePost post)? onPostTap;

  /// A callback function invoked when the user's profile is tapped.
  final Function(BuildContext context, String userId)? onUserTap;

  /// A callback function invoked when a post deletion is requested.
  final Widget Function(BuildContext context, TimelinePost post)? onPostDelete;

  /// Determines whether filtering functionality is enabled for this user story
  /// timeline.
  final bool filterEnabled;

  /// A function that builds a widget for a timeline post.
  final Widget Function(TimelinePost post)? postWidgetBuilder;

  /// Boolean to enable timeline post overview screen before submitting
  final bool enablePostOverviewScreen;

  /// Boolean to enable redirect to home after post creation.
  /// If false, it will redirect to created post screen
  final bool afterPostCreationGoHome;

  /// Open page builder function for the category selection page. This function
  /// accepts a [BuildContext] and a child widget.
  final Function(
    BuildContext context,
    Widget child,
  )? categorySelectionOpenPageBuilder;
}
