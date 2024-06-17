import 'package:example/config/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_timeline/flutter_timeline.dart';
import 'package:go_router/go_router.dart';

List<GoRoute> getTimelineRoutes() => getTimelineStoryRoutes(
      configuration: getConfig(TimelineService(
        postService: LocalTimelinePostService(),
      )),
    );

final _router = GoRouter(
  initialLocation: '/timeline',
  routes: [
    ...getTimelineRoutes(),
  ],
);

class GoRouterApp extends StatelessWidget {
  const GoRouterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
      title: 'Flutter Timeline',
      theme: ThemeData(
        textTheme: const TextTheme(
            titleLarge: TextStyle(
                color: Color(0xffb71c6d), fontFamily: 'Playfair Display')),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFB8E2E8),
          primary: const Color(0xffb71c6d),
        ).copyWith(
          surface: const Color(0XFFFAF9F6),
        ),
        useMaterial3: true,
      ),
    );
  }
}
