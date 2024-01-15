// SPDX-FileCopyrightText: 2023 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_timeline/flutter_timeline.dart';

// ignore: depend_on_referenced_packages
import 'package:uuid/uuid.dart';

class TestTimelineService with ChangeNotifier implements TimelineService {
  List<TimelinePost> _posts = [];

  @override
  Future<TimelinePost> createPost(TimelinePost post) async {
    _posts.add(post);
    notifyListeners();
    return post;
  }

  @override
  Future<void> deletePost(TimelinePost post) async {
    _posts = _posts.where((element) => element.id != post.id).toList();

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
      _posts = _posts
          .map(
            (p) => p.id == post.id ? updatedPost : p,
          )
          .toList();

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
      updatedReactions.add(reaction.copyWith(
          creator: const TimelinePosterUserModel(userId: 'test_user')));
    }
    var updatedPost = post.copyWith(reactions: updatedReactions);
    _posts = _posts.map((p) => (p.id == post.id) ? updatedPost : p).toList();
    notifyListeners();
    return updatedPost;
  }

  @override
  Future<List<TimelinePost>> fetchPosts(String? category) async {
    print('fetch posts');
    var posts = getMockedPosts();
    _posts = posts;
    notifyListeners();
    return posts;
  }

  @override
  Future<List<TimelinePost>> fetchPostsPaginated(
    String? category,
    int limit,
  ) async {
    notifyListeners();
    return _posts;
  }

  @override
  Future<TimelinePost> fetchPost(TimelinePost post) async {
    notifyListeners();
    return post;
  }

  @override
  Future<List<TimelinePost>> refreshPosts(String? category) async {
    var posts = <TimelinePost>[];

    _posts = [...posts, ..._posts];
    notifyListeners();
    return posts;
  }

  @override
  TimelinePost? getPost(String postId) =>
      (_posts.any((element) => element.id == postId))
          ? _posts.firstWhere((element) => element.id == postId)
          : null;

  @override
  List<TimelinePost> getPosts(String? category) => _posts
      .where((element) => category == null || element.category == category)
      .toList();

  @override
  Future<TimelinePost> likePost(String userId, TimelinePost post) async {
    var updatedPost = post.copyWith(
      likes: post.likes + 1,
      likedBy: post.likedBy?..add(userId),
    );
    _posts = _posts
        .map(
          (p) => p.id == post.id ? updatedPost : p,
        )
        .toList();

    notifyListeners();
    return updatedPost;
  }

  @override
  Future<TimelinePost> unlikePost(String userId, TimelinePost post) async {
    var updatedPost = post.copyWith(
      likes: post.likes - 1,
      likedBy: post.likedBy?..remove(userId),
    );
    _posts = _posts
        .map(
          (p) => p.id == post.id ? updatedPost : p,
        )
        .toList();

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
    var updatedReaction = reaction.copyWith(
        id: reactionId,
        creator: const TimelinePosterUserModel(userId: 'test_user'));


    var updatedPost = post.copyWith(
      reaction: post.reaction + 1,
      reactions: post.reactions?..add(updatedReaction),
    );

 
    _posts = _posts
        .map(
          (p) => p.id == post.id ? updatedPost : p,
        )
        .toList();
    notifyListeners();
    return updatedPost;
  }

  List<TimelinePost> getMockedPosts() {
    return [
      TimelinePost(
        id: 'Post0',
        creatorId: 'test_user',
        title: 'Post 0',
        category: 'text',
        content: "Post 0 content",
        likes: 0,
        reaction: 0,
        createdAt: DateTime.now(),
        reactionEnabled: false,
      )
    ];
  }
}
