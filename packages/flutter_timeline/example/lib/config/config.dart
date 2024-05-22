import 'package:flutter/material.dart';
import 'package:flutter_timeline/flutter_timeline.dart';

TimelineUserStoryConfiguration getConfig(TimelineService service) {
  return TimelineUserStoryConfiguration(
    service: service,
    userId: 'test_user',
    optionsBuilder: (context) => options,
    enablePostOverviewScreen: false,
  );
}

var options = TimelineOptions(
  textInputBuilder: null,
  paddings: TimelinePaddingOptions(
    mainPadding: const EdgeInsets.all(20).copyWith(top: 28),
  ),
  allowAllDeletion: true,
  categoriesOptions: CategoriesOptions(
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
  ),
);

void navigateToOverview(
  BuildContext context,
  TimelineService service,
  TimelineOptions options,
  TimelinePost post,
) {
  if (context.mounted) {
    Navigator.of(context).pop();
  }
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => TimelinePostOverviewScreen(
        timelinePost: post,
        options: options,
        service: service,
        onPostSubmit: (post) {
          service.postService.createPost(post);
          if (context.mounted) {
            Navigator.of(context).pop();
          }
        },
      ),
    ),
  );
}

void createPost(
    BuildContext context,
    TimelineService service,
    TimelineOptions options,
    TimelineUserStoryConfiguration configuration) async {
  await Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (context) => Scaffold(
        body: TimelinePostCreationScreen(
          postCategory: 'category1',
          userId: 'test_user',
          service: service,
          options: options,
          onPostCreated: (post) {
            Navigator.of(context).pop();
          },
          onPostOverview: (post) {
            navigateToOverview(context, service, options, post);
          },
          enablePostOverviewScreen: configuration.enablePostOverviewScreen,
        ),
      ),
    ),
  );
}

void generatePost(TimelineService service) {
  var amountOfPosts = service.postService.getPosts(null).length;

  service.postService.createPost(
    TimelinePost(
      id: 'Post$amountOfPosts',
      creatorId: 'test_user',
      title: 'Post $amountOfPosts',
      category: amountOfPosts % 2 == 0 ? 'category1' : 'category2',
      content: "Post $amountOfPosts content",
      likes: 0,
      reaction: 0,
      creator: const TimelinePosterUserModel(
        userId: 'test_user',
        imageUrl:
            'https://cdn.britannica.com/68/143568-050-5246474F/Donkey.jpg?w=400&h=300&c=crop',
        firstName: 'Dirk',
        lastName: 'lukassen',
      ),
      createdAt: DateTime.now(),
      reactionEnabled: amountOfPosts % 2 == 0 ? false : true,
      imageUrl: amountOfPosts % 3 != 0
          ? 'https://s3-eu-west-1.amazonaws.com/sortlist-core-api/6qpvvqjtmniirpkvp8eg83bicnc2'
          : null,
    ),
  );
}
