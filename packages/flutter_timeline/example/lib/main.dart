import 'package:example/post_screen.dart';
import 'package:example/timeline_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_timeline/flutter_timeline.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  initializeDateFormatting();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Timeline',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
  });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var timelineService = TestTimelineService();

  @override
  Widget build(BuildContext context) {
    print('test');
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          createPost();
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      body: SafeArea(
        child: TimelineScreen(
          userId: 'test_id',
          options: const TimelineOptions(),
          onPostTap: (post) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PostScreen(
                  service: timelineService,
                  post: post,
                ),
              ),
            );
          },
          service: timelineService,
        ),
      ),
    );
  }

  void createPost() {
    print('creating post');
    var amountOfPosts = timelineService.getPosts('text').length;

    timelineService.createPost(
      TimelinePost(
        id: 'Post$amountOfPosts',
        creatorId: 'test_user',
        title: 'Post $amountOfPosts',
        category: 'text',
        content: "Post $amountOfPosts content",
        likes: 0,
        reaction: 0,
        createdAt: DateTime.now(),
        reactionEnabled: false,
      ),
    );
  }
}
