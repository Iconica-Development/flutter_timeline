import "dart:async";
import "dart:typed_data";

import "package:rxdart/rxdart.dart";
import "package:timeline_repository_interface/src/interfaces/post_repository_interface.dart";
import "package:timeline_repository_interface/src/models/timeline_post.dart";
import "package:timeline_repository_interface/src/models/timeline_post_reaction.dart";
import "package:timeline_repository_interface/src/models/timeline_user.dart";

class LocalPostRepository implements PostRepositoryInterface {
  LocalPostRepository();

  final StreamController<List<TimelinePost>> _postsController =
      BehaviorSubject<List<TimelinePost>>();

  late TimelinePost? _currentPost;

  final jane = const TimelineUser(
    userId: "1",
    firstName: "Jane",
    lastName: "Doe",
    imageUrl: "https://via.placeholder.com/150",
  );

  final List<TimelinePost> _posts = List.generate(
    10,
    (index) => TimelinePost(
      id: index.toString(),
      creatorId: "1",
      title: "test title",
      content: "lore ipsum, dolor sit amet, consectetur adipiscing elit,"
          " sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
      likes: 50,
      reaction: 5,
      createdAt: DateTime.now(),
      reactionEnabled: true,
      category: "2",
      reactions: [
        TimelinePostReaction(
          id: "2",
          postId: index.toString(),
          creatorId: "1",
          createdAt: DateTime.now(),
          reaction: "This is a test reaction",
          likedBy: [],
          creator: const TimelineUser(
            userId: "2",
            firstName: "John",
            lastName: "Doe",
            imageUrl: "https://via.placeholder.com/150",
          ),
        ),
      ],
      likedBy: [],
      creator: const TimelineUser(
        userId: "1",
        firstName: "Jane",
        lastName: "Doe",
        imageUrl: "https://via.placeholder.com/150",
      ),
      imageUrl: "https://via.placeholder.com/1000",
    ),
  );

  @override
  Stream<List<TimelinePost>> getPosts(String? categoryId) {
    if (categoryId == null) {
      _postsController.add(_posts);
    } else {
      _postsController.add(
        _posts.where((element) => element.category == categoryId).toList(),
      );
    }
    return _postsController.stream;
  }

  @override
  Future<void> deletePost(String id) async {
    _posts.removeWhere((element) => element.id == id);
    _postsController.add(_posts);
  }

  @override
  Future<void> likePost(String postId, String userId) async {
    var post = _posts.firstWhere((element) => element.id == postId);
    var updatedPost = post.copyWith(
      likes: post.likes + 1,
      likedBy: post.likedBy?..add(userId),
    );
    _posts[_posts.indexWhere((element) => element.id == postId)] = updatedPost;
    _postsController.add(_posts);
  }

  @override
  Future<void> unlikePost(String postId, String userId) async {
    var post = _posts.firstWhere((element) => element.id == postId);
    var updatedPost = post.copyWith(
      likes: post.likes - 1,
      likedBy: post.likedBy?..remove(userId),
    );
    _posts[_posts.indexWhere((element) => element.id == postId)] = updatedPost;
    _postsController.add(_posts);
  }

  @override
  Future<void> likePostReaction(
    TimelinePost post,
    TimelinePostReaction reaction,
    String userId,
  ) async {
    var updatedPost = post.copyWith(
      reaction: post.reaction + 1,
      reactions: post.reactions
        ?..[post.reactions!
                .indexWhere((element) => element.id == reaction.id)] =
            reaction.copyWith(
          likedBy: reaction.likedBy?..add(userId),
        ),
    );
    _posts[_posts.indexWhere((element) => element.id == post.id)] = updatedPost;
    _postsController.add(_posts);
  }

  @override
  Future<void> unlikePostReaction(
    TimelinePost post,
    TimelinePostReaction reaction,
    String userId,
  ) async {
    var updatedPost = post.copyWith(
      reaction: post.reaction - 1,
      reactions: post.reactions
        ?..[post.reactions!
                .indexWhere((element) => element.id == reaction.id)] =
            reaction.copyWith(
          likedBy: reaction.likedBy?..remove(userId),
        ),
    );
    _posts[_posts.indexWhere((element) => element.id == post.id)] = updatedPost;
    _postsController.add(_posts);
  }

  @override
  Future<void> createReaction(
    TimelinePost post,
    TimelinePostReaction reaction, {
    Uint8List? image,
  }) async {
    var reactionId = DateTime.now().millisecondsSinceEpoch.toString();
    var updatedReaction = reaction.copyWith(
      id: reactionId,
      creator: const TimelineUser(
        userId: "2",
        firstName: "John",
        lastName: "Doe",
        imageUrl: "https://via.placeholder.com/150",
      ),
    );

    var updatedPost = post.copyWith(
      reaction: post.reaction + 1,
      reactions: post.reactions?..add(updatedReaction),
    );
    _posts[_posts.indexWhere((element) => element.id == post.id)] = updatedPost;
    _postsController.add(_posts);
  }

  @override
  Future<void> setCurrentPost(TimelinePost post) async {
    _currentPost = post;
  }

  @override
  TimelinePost getCurrentPost() => _currentPost!;

  @override
  Future<void> createPost(TimelinePost post) async {
    var postId = DateTime.now().millisecondsSinceEpoch.toString();
    var updatedPost = post.copyWith(
      id: postId,
      creator: jane,
      createdAt: DateTime.now(),
    );
    _posts.add(updatedPost);
    _postsController.add(_posts);
  }
}
