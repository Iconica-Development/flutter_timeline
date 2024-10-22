import "package:flutter/material.dart";
import "package:flutter_timeline/src/models/timeline_options.dart";
import "package:flutter_timeline/src/widgets/category_list.dart";
import "package:flutter_timeline/src/widgets/post_list.dart";
import "package:timeline_repository_interface/timeline_repository_interface.dart";

class TimelineScreen extends StatefulWidget {
  const TimelineScreen({
    required this.options,
    required this.timelineService,
    required this.onTapPost,
    required this.currentUserId,
    required this.onTapComments,
    required this.onTapCreatePost,
    super.key,
  });
  final TimelineService timelineService;
  final TimelineOptions options;
  final Function(TimelinePost post) onTapPost;
  final String currentUserId;
  final Function(TimelinePost post) onTapComments;
  final Function() onTapCreatePost;

  @override
  State<TimelineScreen> createState() => _TimelineScreenState();
}

class _TimelineScreenState extends State<TimelineScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _isOnTop = true;
  List<TimelineCategory> categories = [];

  @override
  void initState() {
    _scrollController.addListener(_updateIsOnTop);
    if (widget.timelineService.getSelectedCategory() == null) {
      widget.timelineService.selectCategory(widget.options.initialCategoryId);
    }
    super.initState();
  }

  void _updateIsOnTop() {
    setState(() {
      _isOnTop = _scrollController.position.pixels < 0.1;
    });
  }

  @override
  Widget build(BuildContext context) {
    var translations = widget.options.translations;
    var theme = Theme.of(context);
    return Scaffold(
      drawer: widget.options.timelineScreenDrawer,
      floatingActionButton: widget.options
          .floatingActionButtonBuilder(widget.onTapCreatePost, context),
      appBar: widget.options.timelineScreenAppBarBuilder
              ?.call(context, translations.timelineTitle) ??
          AppBar(
            title: Text(
              translations.timelineTitle,
              style: theme.textTheme.headlineLarge,
            ),
          ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StreamBuilder(
            stream: widget.timelineService.getCategories(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                categories = snapshot.data!;

                return CategoryList(
                  selectedCategory:
                      widget.timelineService.getSelectedCategory(),
                  categories: categories,
                  isOnTop: _isOnTop,
                  onTap: (category) {
                    widget.timelineService.selectCategory(category.key);
                    setState(() {});
                  },
                );
              } else {
                return const CircularProgressIndicator();
              }
            },
          ),
          StreamBuilder(
            stream: widget.timelineService.postRepository
                .getPosts(widget.timelineService.getSelectedCategory()?.key),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var posts = snapshot.data!;
                return PostList(
                  timelineService: widget.timelineService,
                  currentUserId: widget.currentUserId,
                  controller: _scrollController,
                  onTapPost: widget.onTapPost,
                  onTapComments: widget.onTapComments,
                  options: widget.options,
                  posts: posts,
                );
              } else {
                return const CircularProgressIndicator();
              }
            },
          ),
        ],
      ),
    );
  }
}
