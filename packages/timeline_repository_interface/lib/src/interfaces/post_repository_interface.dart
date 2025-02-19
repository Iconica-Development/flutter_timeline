import "dart:typed_data";

import "package:timeline_repository_interface/timeline_repository_interface.dart";

abstract class PostRepositoryInterface {
  Stream<List<TimelinePost>> getPosts(String? categoryId);
  Future<void> deletePost(String id);
  //like post
  Future<void> likePost(String postId, String userId);
  Future<void> unlikePost(String postId, String userId);
  Future<void> likePostReaction(
    TimelinePost post,
    TimelinePostReaction reaction,
    String userId,
  );
  Future<void> unlikePostReaction(
    TimelinePost post,
    TimelinePostReaction reaction,
    String userId,
  );
  Future<void> createReaction(
    TimelinePost post,
    TimelinePostReaction reaction, {
    Uint8List? image,
  });

  void setCurrentPost(TimelinePost post);
  TimelinePost getCurrentPost();
  Future<void> createPost(TimelinePost post);
}
