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
  List<TimelineCategory> categories = [];

  @override
  TimelineCategory? selectedCategory;

  @override
  Future<TimelinePost> createPost(TimelinePost post) async {
    posts.add(
      post.copyWith(
        creator: const TimelinePosterUserModel(
          userId: 'test_user',
          imageUrl:
              'https://cdn.britannica.com/68/143568-050-5246474F/Donkey.jpg?w=400&h=300&c=crop',
          firstName: 'Ico',
          lastName: 'Nica',
        ),
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
          creator: const TimelinePosterUserModel(
            userId: 'test_user',
            imageUrl:
                'https://cdn.britannica.com/68/143568-050-5246474F/Donkey.jpg?w=400&h=300&c=crop',
            firstName: 'Dirk',
            lastName: 'lukassen',
          ),
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
    if (posts.isEmpty) {
      posts = getMockedPosts();
    }
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
      creator: const TimelinePosterUserModel(
        userId: 'test_user',
        imageUrl:
            'https://cdn.britannica.com/68/143568-050-5246474F/Donkey.jpg?w=400&h=300&c=crop',
        firstName: 'Ico',
        lastName: 'Nica',
      ),
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
          title: 'De topper van de maand september',
          category: 'Category',
          imageUrl:
              'https://firebasestorage.googleapis.com/v0/b/appshell-demo.appspot.com/o/do_not_delete_1.png?alt=media&token=e4b2f9f3-c81f-4ac7-a938-e846691399f7',
          content: 'Dit is onze topper van de maand september! Gefeliciteerd!',
          likes: 72,
          reaction: 0,
          createdAt: DateTime.now(),
          reactionEnabled: true,
          creator: const TimelinePosterUserModel(
            userId: 'test_user',
            imageUrl:
                'https://firebasestorage.googleapis.com/v0/b/appshell-demo.appspot.com/o/do_not_delete_3.png?alt=media&token=cd7c156d-0dda-43be-9199-f7d31c30132e',
            firstName: 'Robin',
            lastName: 'De Vries',
          ),
        ),
        TimelinePost(
          id: 'Post1',
          creatorId: 'test_user2',
          title: 'De soep van de week is: Aspergesoep',
          category: 'Category with two lines',
          content:
              'Aspergesoep is echt een heerlijke delicatesse. Deze soep wordt'
              ' vaak gemaakt met verse asperges, bouillon en wat kruiden voor'
              ' smaak. Het is een perfecte keuze voor een lichte en smaakvolle'
              ' maaltijd, vooral in het voorjaar wanneer asperges in seizoen'
              ' zijn. We serveren het met een vleugje room en wat knapperige'
              ' croutons voor die extra touch.',
          likes: 72,
          reaction: 0,
          createdAt: DateTime.now(),
          reactionEnabled: true,
          imageUrl:
              'https://firebasestorage.googleapis.com/v0/b/appshell-demo.appspot.com/o/do_not_delete_2.png?alt=media&token=ee4a8771-531f-4d1d-8613-a2366771e775',
          creator: const TimelinePosterUserModel(
            userId: 'test_user',
            imageUrl:
                'https://firebasestorage.googleapis.com/v0/b/appshell-demo.appspot.com/o/do_not_delete_4.png?alt=media&token=775d4d10-6d2b-4aef-a51b-ba746b7b137f',
            firstName: 'Elise',
            lastName: 'Welling',
          ),
        ),
      ];

  @override
  Future<bool> addCategory(TimelineCategory category) async {
    categories.add(category);
    notifyListeners();
    return true;
  }

  @override
  Future<List<TimelineCategory>> fetchCategories() async {
    categories = [
      const TimelineCategory(key: null, title: 'All'),
      const TimelineCategory(
        key: 'Category',
        title: 'Category',
      ),
      const TimelineCategory(
        key: 'Category with two lines',
        title: 'Category with two lines',
      ),
    ];
    notifyListeners();

    return categories;
  }
}
