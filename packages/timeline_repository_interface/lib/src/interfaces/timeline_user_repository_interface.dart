import "package:timeline_repository_interface/src/models/timeline_user.dart";

abstract class TimelineUserRepositoryInterface {
  Future<List<TimelineUser>> getAllUsers();
  Future<TimelineUser> getCurrentUser();
  Future<TimelineUser?> getUser(String userId);
}
