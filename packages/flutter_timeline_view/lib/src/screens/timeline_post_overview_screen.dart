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
    super.key,
  });
  final TimelinePost timelinePost;
  final TimelineOptions options;
  final TimelineService service;
  final void Function(TimelinePost) onPostSubmit;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          options.translations.postOverview,
          style: TextStyle(color: Theme.of(context).primaryColor),
        ),
      ),
      body: Column(
        children: [
          Flexible(
            child: TimelinePostScreen(
              userId: timelinePost.creatorId,
              options: options,
              post: timelinePost,
              onPostDelete: () async {},
              service: service,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 30.0),
            child: ElevatedButton(
              onPressed: () {
                onPostSubmit(timelinePost);
              },
              child: Text(
                '${options.translations.postIn} ${timelinePost.category}',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
