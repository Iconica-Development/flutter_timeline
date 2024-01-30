import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_timeline/flutter_timeline.dart';
import 'package:uuid/uuid.dart';

class TestTimelineService
    with ChangeNotifier
    implements TimelineService, TimelineUserService {
  List<TimelinePost> _posts = [];

  List<TimelinePost> get posts => _posts;

  @override
  Future<TimelinePost> createPost(TimelinePost post) async {
    _posts.add(
      post.copyWith(
        creator: const TimelinePosterUserModel(userId: 'test_user'),
      ),
    );
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
      likedBy: (post.likedBy ?? [])..add(userId),
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
      for (var i = 0; i < 20; i++) ...[
        if (i == 0) ...[
          TimelinePost(
            id: 'Post$i',
            creatorId: 'test_user',
            title: 'Post $i',
            category: 'text',
            content: "Post $i content",
            likes: i,
            reaction: 0,
            reactions: getMockedReactions('Post$i'),
            createdAt: DateTime.now().subtract(Duration(days: i % 10)),
            reactionEnabled: true,
            imageUrl: 'https://picsum.photos/seed/$i/200/300',
          )
        ] else ...[
          TimelinePost(
            id: 'Post$i',
            creatorId: 'test_user',
            title: 'Post $i',
            category: 'text',
            content: "Post $i content",
            likes: i,
            reaction: 0,
            createdAt: DateTime.now().subtract(Duration(days: i % 10)),
            reactionEnabled: false,
            imageUrl: 'https://picsum.photos/seed/$i/200/300',
          )
        ],
      ]
    ];
  }

  List<TimelinePostReaction> getMockedReactions(String posdId) {
    return [
      for (var i = 0; i < 20; i++) ...[
        TimelinePostReaction(
          id: 'Reaction$i',
          postId: posdId,
          reaction: 'Reaction $i',
          createdAt: DateTime.now().subtract(Duration(days: i % 10)),
          creatorId: 'test_user',
          imageUrl:
              (i % 2 == 0) ? 'https://picsum.photos/seed/$i/200/300' : null,
        )
      ]
    ];
  }

  @override
  Future<TimelinePosterUserModel?> getUser(String userId) async {
    return TimelinePosterUserModel(
      userId: userId,
    );
  }

  @override
  set posts(List<TimelinePost> posts) {
    _posts = posts;
    notifyListeners();
  }
}
