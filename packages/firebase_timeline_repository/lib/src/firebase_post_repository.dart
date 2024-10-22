import "dart:async";
import "dart:typed_data";

import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_storage/firebase_storage.dart";
import "package:firebase_timeline_repository/firebase_timeline_repository.dart";
import "package:timeline_repository_interface/timeline_repository_interface.dart";

class FirebasePostRepository implements PostRepositoryInterface {
  FirebasePostRepository({
    this.userService,
  }) {
    userService ??= FirebaseUserRepository();
  }

  TimelineUserRepositoryInterface? userService;

  final CollectionReference postCollection =
      FirebaseFirestore.instance.collection("timeline");

  late TimelinePost? _currentPost;

  final List<TimelinePost> _posts = [];

  @override
  Future<void> createPost(TimelinePost post) async {
    var updatedPost = post;
    if (post.image != null) {
      // add image upload logic here
      var imageRef = FirebaseStorage.instance.ref().child("timeline/$post.id");
      var result = await imageRef.putData(post.image!);
      var imageUrl = await result.ref.getDownloadURL();
      updatedPost = post.copyWith(
        imageUrl: imageUrl,
      );
    }
    _posts.add(updatedPost);

    await postCollection.add(updatedPost.toJson());
  }

  @override
  Future<void> createReaction(
    TimelinePost post,
    TimelinePostReaction reaction, {
    Uint8List? image,
  }) async {
    var user = await userService!.getCurrentUser();
    var currentReaction = reaction.copyWith(
      creatorId: user.userId,
      creator: user,
    );
    var updatedPost = post.copyWith(
      reaction: post.reaction + 1,
      reactions: post.reactions
        ?..add(
          currentReaction,
        ),
    );
    await postCollection.doc(post.id).update(updatedPost.toJson());
    _posts[_posts.indexWhere((element) => element.id == post.id)] = updatedPost;
  }

  @override
  Future<void> deletePost(String id) async {
    await postCollection.doc(id).delete();
  }

  @override
  TimelinePost getCurrentPost() => _currentPost!;

  @override
  Stream<List<TimelinePost>> getPosts(String? categoryId) => postCollection
          .where("category", isEqualTo: categoryId)
          .snapshots()
          .asyncMap((snapshot) async {
        // Fetch posts and their associated users
        var posts = await Future.wait(
          snapshot.docs.map((doc) async {
            // Get user who created the post
            var postData = doc.data()! as Map<String, dynamic>;
            var user = await userService!.getUser(postData["creator_id"]);

            // Create post from document data
            var post = TimelinePost.fromJson(doc.id, postData);

            // Update reactions with user details
            if (post.reactions != null) {
              post = post.copyWith(
                reactions: await Future.wait(
                  post.reactions!.map((reaction) async {
                    var reactionUser =
                        await userService!.getUser(reaction.creatorId);
                    return reaction.copyWith(creator: reactionUser);
                  }).toList(),
                ),
              );
            }

            // Return post with creator information
            return post.copyWith(creator: user);
          }).toList(),
        );

        // Update internal post list
        _posts
          ..clear()
          ..addAll(posts);

        return _posts;
      });

  @override
  Future<void> likePost(String postId, String userId) async {
    var post = await postCollection.doc(postId).get();
    var updatedPost =
        TimelinePost.fromJson(post.id, post.data()! as Map<String, dynamic>);
    updatedPost = updatedPost.copyWith(
      likes: updatedPost.likes + 1,
      likedBy: updatedPost.likedBy?..add(userId),
    );
    await postCollection.doc(postId).update(updatedPost.toJson());
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
    await postCollection.doc(post.id).update(updatedPost.toJson());
  }

  @override
  void setCurrentPost(TimelinePost post) {
    _currentPost = post;
  }

  @override
  Future<void> unlikePost(String postId, String userId) async {
    var updatedPost = _posts.firstWhere((element) => element.id == postId);
    updatedPost = updatedPost.copyWith(
      likes: updatedPost.likes - 1,
      likedBy: updatedPost.likedBy?..remove(userId),
    );
    await postCollection.doc(postId).update(updatedPost.toJson());
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

    await postCollection.doc(post.id).update(updatedPost.toJson());
  }
}
