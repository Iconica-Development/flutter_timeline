// SPDX-FileCopyrightText: 2024 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause

import 'package:flutter/material.dart';
import 'package:flutter_timeline/flutter_timeline.dart';

Widget timeLineNavigatorUserStory(
  TimelineUserStoryConfiguration configuration,
  BuildContext context,
) =>
    _timelineScreenRoute(configuration, context);

Widget _timelineScreenRoute(
  TimelineUserStoryConfiguration configuration,
  BuildContext context,
) =>
    TimelineScreen(
      service: configuration.service,
      options: configuration.optionsBuilder(context),
      userId: configuration.userId,
      onPostTap: (post) async =>
          configuration.onPostTap?.call(context, post) ??
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) =>
                  _postDetailScreenRoute(configuration, context, post),
            ),
          ),
      onUserTap: (userId) {
        configuration.onUserTap?.call(context, userId);
      },
    );

Widget _postDetailScreenRoute(
  TimelineUserStoryConfiguration configuration,
  BuildContext context,
  TimelinePost post,
) =>
    TimelinePostScreen(
      userId: configuration.userId,
      service: configuration.service,
      options: configuration.optionsBuilder(context),
      post: post,
      onPostDelete: () async {
        configuration.onPostDelete?.call(context, post) ??
            await configuration.service.deletePost(post);
      },
    );
