import "package:flutter/material.dart";
import "package:flutter_timeline/flutter_timeline.dart";

class TimelinePostOverview extends StatefulWidget {
  const TimelinePostOverview({
    required this.timelineService,
    required this.options,
    required this.onTapCreatePost,
    super.key,
  });

  final TimelineService timelineService;
  final TimelineOptions options;
  final Function(TimelinePost post) onTapCreatePost;

  @override
  State<TimelinePostOverview> createState() => _TimelinePostOverviewState();
}

class _TimelinePostOverviewState extends State<TimelinePostOverview> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    var currentPost = widget.timelineService.getCurrentPost();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.options.translations.addPost,
        ),
      ),
      body: CustomScrollView(
        shrinkWrap: true,
        slivers: [
          SliverList(
            delegate: SliverChildListDelegate([
              Column(
                children: [
                  TimelinePostWidget(
                    timelineService: widget.timelineService,
                    post: currentPost,
                    options: widget.options,
                    currentUserId: currentPost.creatorId,
                    onTapPost: (post) {},
                    onTapComments: (post) {},
                    isInDetailView: true,
                    isInPostOverview: true,
                  ),
                ],
              ),
            ]),
          ),
          SliverFillRemaining(
            hasScrollBody: false,
            fillOverscroll: false,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                widget.options.buttonBuilder(
                  title: widget.options.translations.postButtonTitle,
                  onPressed: () async {
                    if (isLoading) return;
                    isLoading = true;
                    await widget.timelineService.createPost(currentPost);
                    widget.options.onCreatePost?.call(currentPost);
                    widget.onTapCreatePost(currentPost);
                  },
                  context: context,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
