// ignore_for_file: prefer_expression_function_bodies

import 'package:flutter/material.dart';
import 'package:flutter_timeline_interface/flutter_timeline_interface.dart';
import 'package:flutter_timeline_view/flutter_timeline_view.dart';

class TimelinePostOverviewScreen extends StatelessWidget {
  const TimelinePostOverviewScreen({
    required this.timelinePost,
    required this.options,
    required this.service,
    required this.onPostSubmit,
    this.isOverviewScreen,
    super.key,
  });
  final TimelinePost timelinePost;
  final TimelineOptions options;
  final TimelineService service;
  final void Function(TimelinePost) onPostSubmit;
  final bool? isOverviewScreen;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Flexible(
          child: TimelinePostScreen(
            userId: timelinePost.creatorId,
            options: options,
            post: timelinePost,
            onPostDelete: () async {},
            service: service,
            isOverviewScreen: isOverviewScreen,
          ),
        ),
        options.postOverviewButtonBuilder?.call(
              context,
              () {
                onPostSubmit(timelinePost);
              },
              '${options.translations.postIn} ${timelinePost.category}',
            ) ??
            Padding(
              padding: const EdgeInsets.only(bottom: 30.0),
              child: ElevatedButton(
                style: const ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(Color(0xff71C6D1)),
                ),
                onPressed: () {
                  onPostSubmit(timelinePost);
                },
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    '${options.translations.postIn} ${timelinePost.category}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ),
      ],
    );
  }
}
