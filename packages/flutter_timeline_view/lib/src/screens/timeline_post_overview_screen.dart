// ignore_for_file: prefer_expression_function_bodies

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_timeline_interface/flutter_timeline_interface.dart';
import 'package:flutter_timeline_view/flutter_timeline_view.dart';

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
    // the timelinePost.category is a key so we need to get the category object
    var timelineCategoryName = options.categoriesOptions.categoriesBuilder
            ?.call(context)
            .firstWhereOrNull((element) => element.key == timelinePost.category)
            ?.title ??
        timelinePost.category;
    var buttonText = '${options.translations.postIn} $timelineCategoryName';
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
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor:
                    MaterialStatePropertyAll(Theme.of(context).primaryColor),
              ),
              onPressed: () {
                onPostSubmit(timelinePost);
              },
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  buttonText,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
        SizedBox(height: options.paddings.postOverviewButtonBottomPadding),
      ],
    );
  }
}
