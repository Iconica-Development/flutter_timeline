// SPDX-FileCopyrightText: 2023 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause

import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_timeline_firebase/src/config/firebase_timeline_options.dart';
import 'package:flutter_timeline_firebase/src/models/firebase_user_document.dart';
import 'package:flutter_timeline_interface/flutter_timeline_interface.dart';
import 'package:uuid/uuid.dart';

class FirebaseTimelinePostService extends TimelinePostService
    with TimelineUserService {
  FirebaseTimelinePostService({
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

  final Map<String, TimelinePosterUserModel> _users = {};

  @override
  Future<TimelinePost> createPost(TimelinePost post) async {
    var postId = const Uuid().v4();
    var user = await _userService.getUser(post.creatorId);
    var updatedPost = post.copyWith(id: postId, creator: user);
    if (post.image != null) {
      var imageRef =
          _storage.ref().child('${_options.timelineCollectionName}/$postId');
      var result = await imageRef.putData(post.image!);
      var imageUrl = await result.ref.getDownloadURL();
      updatedPost = updatedPost.copyWith(imageUrl: imageUrl);
    }
    var postRef =
        _db.collection(_options.timelineCollectionName).doc(updatedPost.id);
    await postRef.set(updatedPost.toJson());
    posts.add(updatedPost);
    notifyListeners();
    return updatedPost;
  }

  @override
  Future<void> deletePost(TimelinePost post) async {
    posts = posts.where((element) => element.id != post.id).toList();
    var postRef = _db.collection(_options.timelineCollectionName).doc(post.id);
    await postRef.delete();
    notifyListeners();
  }

  @override
  Future<TimelinePost> deletePostReaction(
    TimelinePost post,
    String reactionId,
  ) async {
    if (post.reactions != null && post.reactions!.isNotEmpty) {
      var reaction =
          post.reactions!.firstWhere((element) => element.id == reactionId);
      var updatedPost = post.copyWith(
        reaction: post.reaction - 1,
        reactions: (post.reactions ?? [])..remove(reaction),
      );
      posts = posts
          .map(
            (p) => p.id == post.id ? updatedPost : p,
          )
          .toList();
      var postRef =
          _db.collection(_options.timelineCollectionName).doc(post.id);
      await postRef.update({
        'reaction': FieldValue.increment(-1),
        'reactions': FieldValue.arrayRemove(
          [reaction.toJsonWithMicroseconds()],
        ),
      });
      notifyListeners();
      return updatedPost;
    }
    return post;
  }

  @override
  Future<TimelinePost> fetchPostDetails(TimelinePost post) async {
    var reactions = post.reactions ?? [];
    var updatedReactions = <TimelinePostReaction>[];
    for (var reaction in reactions) {
      var user = await _userService.getUser(reaction.creatorId);
      if (user != null) {
        updatedReactions.add(reaction.copyWith(creator: user));
      }
    }
    var updatedPost = post.copyWith(reactions: updatedReactions);
    posts = posts.map((p) => (p.id == post.id) ? updatedPost : p).toList();
    notifyListeners();
    return updatedPost;
  }

  @override
  Future<List<TimelinePost>> fetchPosts(String? category) async {
    debugPrint('fetching posts from firebase with category: $category');
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

    notifyListeners();
    return posts;
  }

  @override
  Future<List<TimelinePost>> fetchPostsPaginated(
    String? category,
    int limit,
  ) async {
    // only take posts that are in our category
    var oldestPost = posts
        .where(
          (element) => category == null || element.category == category,
        )
        .fold(
          posts.first,
          (previousValue, element) =>
              (previousValue.createdAt.isBefore(element.createdAt))
                  ? previousValue
                  : element,
        );
    var snapshot = (category != null)
        ? await _db
            .collection(_options.timelineCollectionName)
            .where('category', isEqualTo: category)
            .orderBy('created_at', descending: true)
            .startAfter([oldestPost])
            .limit(limit)
            .get()
        : await _db
            .collection(_options.timelineCollectionName)
            .orderBy('created_at', descending: true)
            .startAfter([oldestPost.createdAt])
            .limit(limit)
            .get();
    // add the new posts to the list
    var newPosts = <TimelinePost>[];
    for (var doc in snapshot.docs) {
      var data = doc.data();
      var user = await _userService.getUser(data['creator_id']);
      var post = TimelinePost.fromJson(doc.id, data).copyWith(creator: user);
      newPosts.add(post);
    }
    posts = [...posts, ...newPosts];
    notifyListeners();
    return newPosts;
  }

  @override
  Future<TimelinePost> fetchPost(TimelinePost post) async {
    var doc = await _db
        .collection(_options.timelineCollectionName)
        .doc(post.id)
        .get();
    var data = doc.data();
    if (data == null) return post;
    var user = await _userService.getUser(data['creator_id']);
    var updatedPost = TimelinePost.fromJson(doc.id, data).copyWith(
      creator: user,
    );
    posts = posts.map((p) => (p.id == post.id) ? updatedPost : p).toList();
    notifyListeners();
    return updatedPost;
  }

  @override
  Future<List<TimelinePost>> refreshPosts(String? category) async {
    // fetch all posts between now and the newest posts we have
    var newestPostWeHave = posts
        .where(
          (element) => category == null || element.category == category,
        )
        .fold(
          posts.first,
          (previousValue, element) =>
              (previousValue.createdAt.isAfter(element.createdAt))
                  ? previousValue
                  : element,
        );
    var snapshot = (category != null)
        ? await _db
            .collection(_options.timelineCollectionName)
            .where('category', isEqualTo: category)
            .orderBy('created_at', descending: true)
            .endBefore([newestPostWeHave.createdAt]).get()
        : await _db
            .collection(_options.timelineCollectionName)
            .orderBy('created_at', descending: true)
            .endBefore([newestPostWeHave.createdAt]).get();
    // add the new posts to the list
    var newPosts = <TimelinePost>[];
    for (var doc in snapshot.docs) {
      var data = doc.data();
      var user = await _userService.getUser(data['creator_id']);
      var post = TimelinePost.fromJson(doc.id, data).copyWith(creator: user);
      newPosts.add(post);
    }
    posts = [...posts, ...newPosts];
    notifyListeners();
    return newPosts;
  }

  @override
  TimelinePost? getPost(String postId) =>
      (posts.any((element) => element.id == postId))
          ? posts.firstWhere((element) => element.id == postId)
          : null;

  @override
  List<TimelinePost> getPosts(String? category) => posts
      .where((element) => category == null || element.category == category)
      .toList();

  @override
  Future<TimelinePost> likePost(String userId, TimelinePost post) async {
    // update the post with the new like
    var updatedPost = post.copyWith(
      likes: post.likes + 1,
      likedBy: post.likedBy?..add(userId),
    );
    posts = posts
        .map(
          (p) => p.id == post.id ? updatedPost : p,
        )
        .toList();
    var postRef = _db.collection(_options.timelineCollectionName).doc(post.id);
    await postRef.update({
      'likes': FieldValue.increment(1),
      'liked_by': FieldValue.arrayUnion([userId]),
    });
    notifyListeners();
    return updatedPost;
  }

  @override
  Future<TimelinePost> unlikePost(String userId, TimelinePost post) async {
    // update the post with the new like
    var updatedPost = post.copyWith(
      likes: post.likes - 1,
      likedBy: post.likedBy?..remove(userId),
    );
    posts = posts
        .map(
          (p) => p.id == post.id ? updatedPost : p,
        )
        .toList();
    var postRef = _db.collection(_options.timelineCollectionName).doc(post.id);
    await postRef.update({
      'likes': FieldValue.increment(-1),
      'liked_by': FieldValue.arrayRemove([userId]),
    });
    notifyListeners();
    return updatedPost;
  }

  @override
  Future<TimelinePost> reactToPost(
    TimelinePost post,
    TimelinePostReaction reaction, {
    Uint8List? image,
  }) async {
    var reactionId = const Uuid().v4();
    // also fetch the user information and add it to the reaction
    var user = await _userService.getUser(reaction.creatorId);
    var updatedReaction = reaction.copyWith(id: reactionId, creator: user);
    if (image != null) {
      var imageRef = _storage
          .ref()
          .child('${_options.timelineCollectionName}/${post.id}/$reactionId}');
      var result = await imageRef.putData(image);
      var imageUrl = await result.ref.getDownloadURL();
      updatedReaction = updatedReaction.copyWith(imageUrl: imageUrl);
    }

    var updatedPost = post.copyWith(
      reaction: post.reaction + 1,
      reactions: post.reactions?..add(updatedReaction),
    );

    var postRef = _db.collection(_options.timelineCollectionName).doc(post.id);
    await postRef.update({
      'reaction': FieldValue.increment(1),
      'reactions': FieldValue.arrayUnion([updatedReaction.toJson()]),
    });
    posts = posts
        .map(
          (p) => p.id == post.id ? updatedPost : p,
        )
        .toList();
    notifyListeners();
    return updatedPost;
  }

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
