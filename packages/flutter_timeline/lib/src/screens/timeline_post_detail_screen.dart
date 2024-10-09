import "package:flutter/material.dart";
import "package:flutter_svg/svg.dart";
import "package:flutter_timeline/flutter_timeline.dart";
import "package:flutter_timeline/src/widgets/reaction_textfield.dart";
import "package:flutter_timeline/src/widgets/timeline_post.dart";
import "package:timeline_repository_interface/timeline_repository_interface.dart";

class TimelinePostDetailScreen extends StatefulWidget {
  const TimelinePostDetailScreen({
    required this.post,
    required this.timelineService,
    required this.options,
    required this.currentUserId,
    required this.currentUser,
    super.key,
  });

  final TimelinePost post;
  final TimelineService timelineService;
  final TimelineOptions options;
  final String currentUserId;
  final TimelineUser? currentUser;

  @override
  State<TimelinePostDetailScreen> createState() =>
      _TimelinePostDetailScreenState();
}

class _TimelinePostDetailScreenState extends State<TimelinePostDetailScreen> {
  final TextEditingController _commentController = TextEditingController();
  TimelineCategory? selectedCategory;

  @override
  void initState() {
    selectedCategory = widget.timelineService.categoryRepository
        .selectCategory(widget.post.category);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          selectedCategory?.key == null
              ? widget.timelineService
                      .getCategory(widget.post.category)
                      ?.title ??
                  ""
              : selectedCategory?.title ?? "",
          style: theme.textTheme.headlineLarge,
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: TimelinePostWidget(
              post: widget.post,
              timelineService: widget.timelineService,
              options: widget.options,
              isInDetialView: true,
              currentUserId: widget.currentUserId,
              onTapPost: (post) {},
              onTapComments: (post) {},
            ),
          ),
          if (widget.post.reactionEnabled)
            Align(
              alignment: Alignment.bottomCenter,
              child: ReactionTextfield(
                controller: _commentController,
                options: widget.options,
                user: widget.currentUser,
                suffixIcon: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: IconButton(
                    onPressed: () async {
                      var comment = _commentController.text;
                      if (comment.isNotEmpty) {
                        var reaction = TimelinePostReaction(
                          id: DateTime.now().millisecondsSinceEpoch.toString(),
                          postId: widget.post.id,
                          creatorId: widget.currentUserId,
                          createdAt: DateTime.now(),
                          reaction: comment,
                          likedBy: [],
                        );
                        await widget.timelineService.postRepository
                            .createReaction(
                          widget.post,
                          reaction,
                        );
                        _commentController.clear();
                        setState(() {});
                      }
                    },
                    icon: SvgPicture.asset(
                      "assets/send.svg",
                      package: "flutter_timeline",
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
