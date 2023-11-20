// SPDX-FileCopyrightText: 2023 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause

import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_timeline_firebase/src/config/firebase_timeline_options.dart';
import 'package:flutter_timeline_interface/flutter_timeline_interface.dart';
import 'package:uuid/uuid.dart';

class FirebaseTimelineService implements TimelineService {
  FirebaseTimelineService({
    required TimelineUserService userService,
    FirebaseApp? app,
    options = const FirebaseTimelineOptions(),
  }) {
    var appInstance = app ?? Firebase.app();
    _db = FirebaseFirestore.instanceFor(app: appInstance);
    _storage = FirebaseStorage.instanceFor(app: appInstance);
    _userService = userService;
    _options = options;
  }

  late FirebaseFirestore _db;
  late FirebaseStorage _storage;
  late TimelineUserService _userService;
  late FirebaseTimelineOptions _options;

  List<TimelinePost> _posts = [];

  @override
  Future<TimelinePost> createPost(TimelinePost post) async {
    var postId = const Uuid().v4();
    var imageRef = _storage.ref().child('timeline/$postId');
    var result = await imageRef.putData(post.image!);
    var imageUrl = await result.ref.getDownloadURL();
    var updatedPost = post.copyWith(imageUrl: imageUrl, id: postId);
    var postRef =
        _db.collection(_options.timelineCollectionName).doc(updatedPost.id);
    _posts.add(updatedPost);
    await postRef.set(updatedPost.toJson());
    return updatedPost;
  }

  @override
  Future<void> deletePost(TimelinePost post) async {
    var postRef = _db.collection(_options.timelineCollectionName).doc(post.id);
    return postRef.delete();
  }

  @override
  Future<TimelinePost> fetchPostDetails(TimelinePost post) async {
    debugPrint('fetchPostDetails');
    return post;
  }

  @override
  Future<List<TimelinePost>> fetchPosts(String? category) async {
    var snapshot = (category != null)
        ? await _db
            .collection(_options.timelineCollectionName)
            .where('category', isEqualTo: category)
            .get()
        : await _db.collection(_options.timelineCollectionName).get();

    var posts = <TimelinePost>[];
    for (var doc in snapshot.docs) {
      var data = doc.data();
      var user = await _userService.getUser(data['creator_id']);
      var post = TimelinePost.fromJson(doc.id, data).copyWith(creator: user);
      posts.add(post);
    }
    _posts = posts;
    return posts;
  }

  @override
  List<TimelinePost> getPosts(String? category) => _posts
      .where((element) => category == null || element.category == category)
      .toList();

  @override
  Future<void> likePost(String userId, TimelinePost post) {
    // update the post with the new like
    _posts = _posts
        .map(
          (p) => (p.id == post.id)
              ? p.copyWith(
                  likes: p.likes + 1,
                  likedBy: p.likedBy?..add(userId),
                )
              : p,
        )
        .toList();
    var postRef = _db.collection(_options.timelineCollectionName).doc(post.id);
    return postRef.update({
      'likes': FieldValue.increment(1),
      'liked_by': FieldValue.arrayUnion([userId]),
    });
  }

  @override
  Future<void> unlikePost(String userId, TimelinePost post) {
    // update the post with the new like
    _posts = _posts
        .map(
          (p) => (p.id == post.id)
              ? p.copyWith(
                  likes: p.likes - 1,
                  likedBy: p.likedBy?..remove(userId),
                )
              : p,
        )
        .toList();
    var postRef = _db.collection(_options.timelineCollectionName).doc(post.id);
    return postRef.update({
      'likes': FieldValue.increment(-1),
      'liked_by': FieldValue.arrayRemove([userId]),
    });
  }

  @override
  Future<void> reactToPost(
    TimelinePost post,
    TimelinePostReaction reaction, {
    Uint8List? image,
  }) {
    // update the post with the new reaction
    _posts = _posts
        .map(
          (p) => (p.id == post.id)
              ? p.copyWith(
                  reaction: p.reaction + 1,
                  reactions: p.reactions?..add(reaction),
                )
              : p,
        )
        .toList();
    var postRef = _db.collection(_options.timelineCollectionName).doc(post.id);
    return postRef.update({
      'reaction': FieldValue.increment(1),
      'reactions': FieldValue.arrayUnion([reaction.toJson()]),
    });
  }
}
