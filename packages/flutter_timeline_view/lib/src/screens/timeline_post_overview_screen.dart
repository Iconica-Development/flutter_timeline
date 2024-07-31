// ignore_for_file: prefer_expression_function_bodies

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_timeline_interface/flutter_timeline_interface.dart';
import 'package:flutter_timeline_view/flutter_timeline_view.dart';
import 'package:flutter_timeline_view/src/widgets/default_filled_button.dart';

class TimelinePostOverviewScreen extends StatelessWidget {
  const TimelinePostOverviewScreen({
    required this.timelinePost,
    required this.options,
    required this.service,
    required this.onPostSubmit,
    super.key,
  });
  final TimelinePost timelinePost;
  final TimelineOptions options;
  final TimelineService service;
  final void Function(TimelinePost) onPostSubmit;

  @override
  Widget build(BuildContext context) {
    var timelineCategoryName = service.postService.categories
            .firstWhereOrNull((element) => element.key == timelinePost.category)
            ?.title ??
        timelinePost.category;
    var buttonText = '${options.translations.postIn} $timelineCategoryName';
    var isSubmitted = false;
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          child: TimelinePostScreen(
            userId: timelinePost.creatorId,
            options: options,
            post: timelinePost,
            onPostDelete: () async {},
            service: service,
            isOverviewScreen: true,
          ),
        ),
        options.postOverviewButtonBuilder?.call(
              context,
              () {
                onPostSubmit(timelinePost);
              },
              buttonText,
            ) ??
            options.buttonBuilder?.call(
              context,
              () {
                onPostSubmit(timelinePost);
              },
              buttonText,
              enabled: true,
            ) ??
            SafeArea(
              bottom: true,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 80),
                child: DefaultFilledButton(
                  onPressed: () async {
                    if (isSubmitted) return;
                    isSubmitted = true;
                    onPostSubmit(timelinePost);
                  },
                  buttonText: buttonText,
                ),
              ),
            ),
      ],
    );
  }
}
