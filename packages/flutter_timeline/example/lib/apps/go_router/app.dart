import 'package:example/config/config.dart';
import 'package:example/services/timeline_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_timeline/flutter_timeline.dart';
import 'package:go_router/go_router.dart';

List<GoRoute> getTimelineRoutes() => getTimelineStoryRoutes(
      getConfig(
        TestTimelineService(),
      ),
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
        colorScheme:
            ColorScheme.fromSeed(seedColor: Colors.deepPurple).copyWith(
          background: const Color(0xFFB8E2E8),
        ),
        useMaterial3: true,
      ),
    );
  }
}
