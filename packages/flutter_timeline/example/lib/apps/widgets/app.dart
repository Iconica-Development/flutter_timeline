import 'package:example/config/config.dart';
import 'package:example/services/timeline_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_timeline/flutter_timeline.dart';

class WidgetApp extends StatelessWidget {
  const WidgetApp({super.key});

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
  var timelineOptions = options;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              createPost(context, timelineService, timelineOptions);
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
              generatePost(timelineService);
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
          onPostTap: (post) async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Scaffold(
                  body: TimelinePostScreen(
                    userId: 'test_user',
                    service: timelineService,
                    options: timelineOptions,
                    post: post,
                    onPostDelete: () {
                      timelineService.deletePost(post);
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
