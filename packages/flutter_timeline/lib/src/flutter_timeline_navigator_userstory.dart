import "package:flutter/material.dart";
import "package:flutter_timeline/flutter_timeline.dart";
import "package:timeline_repository_interface/timeline_repository_interface.dart";

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
          await _push(_timelinePostDetailScreenWidget(post, currentUser));
        },
        onTapCreatePost: () async {
          var selectedCategory = timelineService.getSelectedCategory();
          if (selectedCategory?.key != null) {
            await _push(_timelineAddpostInformationScreenWidget());
          } else {
            await _push(_timelineChooseCategoryScreenWidget());
          }
        },
        onTapPost: (post) async {
          var currentUser = await timelineService.getCurrentUser();
          if (context.mounted)
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
          await _push(_timelineAddpostInformationScreenWidget());
        },
      );

  Widget _timelineAddpostInformationScreenWidget() =>
      TimelineAddPostInformationScreen(
        timelineService: timelineService,
        options: widget.options,
        onTapOverview: () async {
          await _push(_timelinePostOverviewWidget());
        },
      );

  Widget _timelinePostOverviewWidget() => TimelinePostOverview(
        timelineService: timelineService,
        options: widget.options,
        onTapCreatePost: (post) async {
          await Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => _timelineScreenWidget(),
            ),
            (route) => route.isFirst,
          );
        },
      );

  Future<void> _push(Widget screen) async {
    await Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => screen));
  }
}
