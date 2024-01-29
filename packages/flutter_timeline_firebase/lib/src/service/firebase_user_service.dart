// SPDX-FileCopyrightText: 2023 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_timeline_firebase/src/config/firebase_timeline_options.dart';
import 'package:flutter_timeline_firebase/src/models/firebase_user_document.dart';
import 'package:flutter_timeline_interface/flutter_timeline_interface.dart';

class FirebaseTimelineUserService implements TimelineUserService {
  FirebaseTimelineUserService({
    FirebaseApp? app,
    options = const FirebaseTimelineOptions(),
  }) {
    var appInstance = app ?? Firebase.app();
    _db = FirebaseFirestore.instanceFor(app: appInstance);
    _options = options;
  }

  late FirebaseFirestore _db;
  late FirebaseTimelineOptions _options;

  final Map<String, TimelinePosterUserModel> _users = {};

  CollectionReference<FirebaseUserDocument> get _userCollection => _db
      .collection(_options.usersCollectionName)
      .withConverter<FirebaseUserDocument>(
        fromFirestore: (snapshot, _) => FirebaseUserDocument.fromJson(
          snapshot.data()!,
          snapshot.id,
        ),
        toFirestore: (user, _) => user.toJson(),
      );
  @override
  Future<TimelinePosterUserModel?> getUser(String userId) async {
    if (_users.containsKey(userId)) {
      return _users[userId]!;
    }
    var data = (await _userCollection.doc(userId).get()).data();

    var user = data == null
        ? TimelinePosterUserModel(userId: userId)
        : TimelinePosterUserModel(
            userId: userId,
            firstName: data.firstName,
            lastName: data.lastName,
            imageUrl: data.imageUrl,
          );

    _users[userId] = user;

    return user;
  }
}
