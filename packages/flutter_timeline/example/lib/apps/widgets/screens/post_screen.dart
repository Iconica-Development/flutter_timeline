import 'package:flutter/material.dart';
import 'package:flutter_timeline/flutter_timeline.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({
    required this.service,
    required this.post,
    super.key,
  });

  final TimelineService service;
  final TimelinePost post;

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TimelinePostScreen(
        userId: 'test_user',
        service: widget.service,
        options: const TimelineOptions(),
        post: widget.post,
        onPostDelete: () {
          Navigator.of(context).pop();
        },
      ),
    );
  }
}

class TestUserService implements TimelineUserService {
  final Map<String, TimelinePosterUserModel> _users = {
    'test_user': const TimelinePosterUserModel(
      userId: 'test_user',
      imageUrl:
          'https://cdn.britannica.com/68/143568-050-5246474F/Donkey.jpg?w=400&h=300&c=crop',
      firstName: 'Dirk',
      lastName: 'lukassen',
    )
  };

  @override
  Future<TimelinePosterUserModel?> getUser(String userId) async {
    if (_users.containsKey(userId)) {
      return _users[userId]!;
    }

    _users[userId] = TimelinePosterUserModel(userId: userId);

    return TimelinePosterUserModel(userId: userId);
  }
}
