import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_timeline_firebase/flutter_timeline_firebase.dart';
import 'package:flutter_timeline_interface/flutter_timeline_interface.dart';

class FirebaseTimelineService implements TimelineService {
  FirebaseTimelineService({
    this.options,
    this.app,
    this.firebasePostService,
    this.firebaseUserService,
  }) {
    firebaseUserService ??= FirebaseTimelineUserService(
      options: options,
      app: app,
    );

    firebasePostService ??= FirebaseTimelinePostService(
      userService: userService,
      options: options,
      app: app,
    );
  }

  final FirebaseTimelineOptions? options;
  final FirebaseApp? app;
  TimelinePostService? firebasePostService;
  TimelineUserService? firebaseUserService;

  @override
  TimelinePostService get postService {
    if (firebasePostService != null) {
      return firebasePostService!;
    } else {
      return FirebaseTimelinePostService(
        userService: userService,
        options: options,
        app: app,
      );
    }
  }

  @override
  TimelineUserService get userService {
    if (firebaseUserService != null) {
      return firebaseUserService!;
    } else {
      return FirebaseTimelineUserService(
        options: options,
        app: app,
      );
    }
  }
}
