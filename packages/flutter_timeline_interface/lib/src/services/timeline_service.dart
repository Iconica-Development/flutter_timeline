import 'package:flutter_timeline_interface/src/services/timeline_post_service.dart';
import 'package:flutter_timeline_interface/src/services/user_service.dart';

class TimelineService {
  TimelineService({
    required this.postService,
    this.userService,
  });

  final TimelinePostService postService;
  final TimelineUserService? userService;
}
