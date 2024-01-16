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
        colorScheme:
            ColorScheme.fromSeed(seedColor: Colors.deepPurple).copyWith(
          background: const Color(0xFFB8E2E8),
        ),
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
  var timelineOptions = TimelineOptions(
    textInputBuilder: null,
    padding: const EdgeInsets.all(20).copyWith(top: 28),
    allowAllDeletion: true,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              createPost();
            },
            child: const Icon(
              Icons.edit,
              color: Colors.white,
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          FloatingActionButton(
            onPressed: () {
              generatePost();
            },
            child: const Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: TimelineScreen(
          userId: 'test_user',
          service: timelineService,
          options: timelineOptions,
        ),
      ),
    );
  }

  void createPost() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          body: TimelinePostCreationScreen(
            postCategory: 'text',
            userId: 'test_user',
            service: timelineService,
            options: timelineOptions,
            onPostCreated: (post) {
              Navigator.of(context).pop();
            },
          ),
        ),
      ),
    );
  }

  void generatePost() {
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
        reactionEnabled: amountOfPosts % 2 == 0 ? false : true,
        imageUrl: amountOfPosts % 3 != 0
            ? 'https://s3-eu-west-1.amazonaws.com/sortlist-core-api/6qpvvqjtmniirpkvp8eg83bicnc2'
            : null,
      ),
    );
  }
}
