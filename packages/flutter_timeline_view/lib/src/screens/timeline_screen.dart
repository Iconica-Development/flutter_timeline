// SPDX-FileCopyrightText: 2023 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause

import 'package:flutter/material.dart';
import 'package:flutter_timeline_interface/flutter_timeline_interface.dart';
import 'package:flutter_timeline_view/src/config/timeline_options.dart';
import 'package:flutter_timeline_view/src/widgets/timeline_post_widget.dart';

class TimelineScreen extends StatefulWidget {
  const TimelineScreen({
    required this.options,
    required this.posts,
    required this.onPostTap,
    this.controller,
    this.timelineCategoryFilter,
    this.timelinePostHeight = 100.0,
    super.key,
  });

  final TimelineOptions options;

  final ScrollController? controller;

  final String? timelineCategoryFilter;

  final double timelinePostHeight;

  final List<TimelinePost> posts;

  final Function(TimelinePost) onPostTap;

  @override
  State<TimelineScreen> createState() => _TimelineScreenState();
}

class _TimelineScreenState extends State<TimelineScreen> {
  late ScrollController controller;

  @override
  void initState() {
    super.initState();
    controller = widget.controller ?? ScrollController();
  }

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        child: Column(
          children: [
            for (var post in widget.posts)
              if (widget.timelineCategoryFilter == null ||
                  post.category == widget.timelineCategoryFilter)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: TimelinePostWidget(
                    options: widget.options,
                    post: post,
                    height: widget.timelinePostHeight,
                    onTap: () => widget.onPostTap.call(post),
                  ),
                ),
          ],
        ),
      );
}
