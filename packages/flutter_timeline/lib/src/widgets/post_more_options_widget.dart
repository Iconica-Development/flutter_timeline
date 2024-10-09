import "package:flutter/material.dart";
import "package:flutter_timeline/flutter_timeline.dart";
import "package:timeline_repository_interface/timeline_repository_interface.dart";

class MoreOptionsButton extends StatelessWidget {
  const MoreOptionsButton({
    required this.timelineService,
    required this.post,
    required this.options,
    super.key,
  });

  final TimelineService timelineService;
  final TimelinePost post;
  final TimelineOptions options;

  @override
  Widget build(BuildContext context) => PopupMenuButton(
        onSelected: (value) async {
          if (value == "delete") {
            options.onPostDelete ?? await timelineService.deletePost(post.id);
          }
        },
        itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
          PopupMenuItem(
            value: "delete",
            child: Text(options.translations.deletePostTitle),
          ),
        ],
        child: const Icon(
          Icons.more_horiz_rounded,
        ),
      );
}
