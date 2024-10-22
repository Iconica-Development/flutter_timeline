import "package:collection/collection.dart";
import "package:timeline_repository_interface/src/interfaces/timeline_user_repository_interface.dart";
import "package:timeline_repository_interface/src/models/timeline_user.dart";

class LocalTimelineUserRepository implements TimelineUserRepositoryInterface {
  final List<TimelineUser> _users = [
    const TimelineUser(
      userId: "1",
      firstName: "john",
      lastName: "doe",
      imageUrl: "https://via.placeholder.com/150",
    ),
    const TimelineUser(
      userId: "2",
      firstName: "jane",
      lastName: "doe",
      imageUrl: "https://via.placeholder.com/150",
    ),
  ];

  List<TimelineUser> loadedUsers = [];

  @override
  Future<List<TimelineUser>> getAllUsers() async {
    loadedUsers = _users;
    return loadedUsers;
  }

  @override
  Future<TimelineUser> getCurrentUser() async =>
      _users.firstWhere((element) => element.userId == "1");

  @override
  Future<TimelineUser?> getUser(String userId) {
    var user = _users.firstWhereOrNull((element) => element.userId == userId);
    return Future.value(user);
  }
}
