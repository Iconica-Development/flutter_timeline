// SPDX-FileCopyrightText: 2023 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_timeline_interface/flutter_timeline_interface.dart';

class LocalTimelinePostService
    with ChangeNotifier
    implements TimelinePostService {
  @override
  List<TimelinePost> posts = [];

  @override
  Future<TimelinePost> createPost(TimelinePost post) async {
    posts.add(
      post.copyWith(
        creator: const TimelinePosterUserModel(userId: 'test_user'),
      ),
    );
    notifyListeners();
    return post;
  }

  @override
  Future<void> deletePost(TimelinePost post) async {
    posts = posts.where((element) => element.id != post.id).toList();

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
      updatedReactions.add(
        reaction.copyWith(
          creator: const TimelinePosterUserModel(userId: 'test_user'),
        ),
      );
    }
    var updatedPost = post.copyWith(reactions: updatedReactions);
    posts = posts.map((p) => (p.id == post.id) ? updatedPost : p).toList();
    notifyListeners();
    return updatedPost;
  }

  @override
  Future<List<TimelinePost>> fetchPosts(String? category) async {
    posts = getMockedPosts();
    notifyListeners();
    return posts;
  }

  @override
  Future<List<TimelinePost>> fetchPostsPaginated(
    String? category,
    int limit,
  ) async {
    notifyListeners();
    return posts;
  }

  @override
  Future<TimelinePost> fetchPost(TimelinePost post) async {
    notifyListeners();
    return post;
  }

  @override
  Future<List<TimelinePost>> refreshPosts(String? category) async {
    var newPosts = <TimelinePost>[];

    posts = [...posts, ...newPosts];
    notifyListeners();
    return posts;
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
    var updatedPost = post.copyWith(
      likes: post.likes + 1,
      likedBy: (post.likedBy ?? [])..add(userId),
    );
    posts = posts
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
    posts = posts
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
    var reactionId = DateTime.now().millisecondsSinceEpoch.toString();

    var updatedReaction = reaction.copyWith(
      id: reactionId,
      creator: const TimelinePosterUserModel(userId: 'test_user'),
    );

    var updatedPost = post.copyWith(
      reaction: post.reaction + 1,
      reactions: post.reactions?..add(updatedReaction),
    );

    posts = posts
        .map(
          (p) => p.id == post.id ? updatedPost : p,
        )
        .toList();
    notifyListeners();
    return updatedPost;
  }

  List<TimelinePost> getMockedPosts() => [
        TimelinePost(
          id: 'Post0',
          creatorId: 'test_user',
          title: 'Post 0',
          category: null,
          content: 'Standard post without image made by the current user',
          likes: 0,
          reaction: 0,
          createdAt: DateTime.now(),
          reactionEnabled: false,
        ),
        TimelinePost(
          id: 'Post1',
          creatorId: 'test_user2',
          title: 'Post 1',
          category: null,
          content: 'Standard post with image made by a different user and '
              'reactions enabled',
          likes: 0,
          reaction: 0,
          createdAt: DateTime.now(),
          reactionEnabled: false,
          imageUrl:
              'https://s3-eu-west-1.amazonaws.com/sortlist-core-api/6qpvvqjtmniirpkvp8eg83bicnc2',
        ),
        TimelinePost(
          id: 'Post2',
          creatorId: 'test_user',
          title: 'Post 2',
          category: null,
          content: 'Standard post with image made by the current user and'
              ' reactions enabled',
          likes: 0,
          reaction: 0,
          createdAt: DateTime.now(),
          reactionEnabled: true,
          imageUrl:
              'https://s3-eu-west-1.amazonaws.com/sortlist-core-api/6qpvvqjtmniirpkvp8eg83bicnc2',
        ),
      ];
}
