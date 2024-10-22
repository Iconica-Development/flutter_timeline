import "package:flutter/material.dart";
import "package:flutter_timeline/flutter_timeline.dart";

class FlutterTimelineNavigatorUserstory extends StatefulWidget {
  const FlutterTimelineNavigatorUserstory({
    required this.currentUserId,
    this.options = const TimelineOptions(),
    this.timelineService,
    super.key,
  });

  final TimelineOptions options;
  final TimelineService? timelineService;
  final String currentUserId;

  @override
  State<FlutterTimelineNavigatorUserstory> createState() =>
      _FlutterTimelineNavigatorUserstoryState();
}

class _FlutterTimelineNavigatorUserstoryState
    extends State<FlutterTimelineNavigatorUserstory> {
  late TimelineService timelineService;

  @override
  void initState() {
    timelineService = widget.timelineService ?? TimelineService();
    super.initState();
  }

  @override
  Widget build(BuildContext context) => _timelineScreenWidget();

  Widget _timelineScreenWidget() => TimelineScreen(
        currentUserId: widget.currentUserId,
        timelineService: timelineService,
        options: widget.options,
        onTapComments: (post) async {
          var currentUser = await timelineService.getCurrentUser();

          await widget.options.onTapComments?.call(post, currentUser) ??
              await _push(_timelinePostDetailScreenWidget(post, currentUser));
        },
        onTapCreatePost: () async {
          var selectedCategory = timelineService.getSelectedCategory();
          if (widget.options.onTapCreatePost != null) {
            await widget.options.onTapCreatePost!(selectedCategory);
          } else {
            if (selectedCategory?.key != null) {
              await _push(_timelineAddpostInformationScreenWidget());
            } else {
              await _push(_timelineChooseCategoryScreenWidget());
            }
          }
        },
        onTapPost: (post) async {
          var currentUser = await timelineService.getCurrentUser();
          if (context.mounted)
            await widget.options.onTapPost?.call(post, currentUser) ??
                await _push(_timelinePostDetailScreenWidget(post, currentUser));
        },
      );

  Widget _timelinePostDetailScreenWidget(
    TimelinePost post,
    TimelineUser currentUser,
  ) =>
      TimelinePostDetailScreen(
        currentUserId: widget.currentUserId,
        timelineService: timelineService,
        currentUser: currentUser,
        options: widget.options,
        post: post,
      );

  Widget _timelineChooseCategoryScreenWidget() => TimelineChooseCategoryScreen(
        timelineService: timelineService,
        options: widget.options,
        ontapCategory: (category) async {
          await widget.options.onTapCategory?.call(category) ??
              await _push(_timelineAddpostInformationScreenWidget());
        },
      );

  Widget _timelineAddpostInformationScreenWidget() =>
      TimelineAddPostInformationScreen(
        timelineService: timelineService,
        options: widget.options,
        onTapOverview: () async {
          await widget.options.onTapOverview?.call() ??
              await _push(_timelinePostOverviewWidget());
        },
      );

  Widget _timelinePostOverviewWidget() => TimelinePostOverview(
        timelineService: timelineService,
        options: widget.options,
        onTapCreatePost: (post) async {
          await widget.options.onTapCreatePostInOverview?.call(post) ??
              await _pushAndRemoveUntil(_timelineScreenWidget());
        },
      );

  Future<void> _push(Widget screen) async {
    await Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => screen));
  }

  Future<void> _pushAndRemoveUntil(Widget screen) async {
    await Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => screen),
      (route) => route.isFirst,
    );
  }
}
