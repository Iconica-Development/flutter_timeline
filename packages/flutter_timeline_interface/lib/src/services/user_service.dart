import 'package:flutter_timeline_interface/src/model/timeline_poster.dart';

mixin TimelineUserService {
  Future<TimelinePosterUserModel?> getUser(String userId);
}
