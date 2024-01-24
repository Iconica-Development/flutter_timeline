import 'package:example/apps/widgets/screens/post_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_timeline/flutter_timeline.dart';

TimelineUserStoryConfiguration getConfig(TimelineService service) {
  return TimelineUserStoryConfiguration(
      service: service,
      userService: TestUserService(),
      userId: 'test_user',
      optionsBuilder: (context) => options);
}

var options = TimelineOptions(
  textInputBuilder: null,
  padding: const EdgeInsets.all(20).copyWith(top: 28),
  allowAllDeletion: true,
  categoriesBuilder: (context) => [
    const TimelineCategory(
      key: null,
      title: 'All',
      icon: SizedBox.shrink(),
    ),
    const TimelineCategory(
      key: 'category1',
      title: 'Category 1',
      icon: SizedBox.shrink(),
    ),
    const TimelineCategory(
      key: 'category2',
      title: 'Category 2',
      icon: SizedBox.shrink(),
    ),
  ],
);

void createPost(BuildContext context, TimelineService service,
    TimelineOptions options) async {
  await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => Scaffold(
        body: TimelinePostCreationScreen(
          postCategory: null,
          userId: 'test_user',
          service: service,
          options: options,
          onPostCreated: (post) {
            Navigator.of(context).pop();
          },
        ),
      ),
    ),
  );
}

void generatePost(TimelineService service) {
  var amountOfPosts = service.getPosts(null).length;

  service.createPost(
    TimelinePost(
      id: 'Post$amountOfPosts',
      creatorId: 'test_user',
      title: 'Post $amountOfPosts',
      category: amountOfPosts % 2 == 0 ? 'category1' : 'category2',
      content: "Post $amountOfPosts content",
      likes: 0,
      reaction: 0,
      createdAt: DateTime.now(),
      reactionEnabled: amountOfPosts % 2 == 0 ? false : true,
      imageUrl: amountOfPosts % 3 != 0
          ? 'https://s3-eu-west-1.amazonaws.com/sortlist-core-api/6qpvvqjtmniirpkvp8eg83bicnc2'
          : null,
    ),
  );
}
