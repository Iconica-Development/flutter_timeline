import "dart:typed_data";
import "package:timeline_repository_interface/src/local/local_timeline_user_repository.dart";
import "package:timeline_repository_interface/timeline_repository_interface.dart";

class TimelineService {
  TimelineService({
    CategoryRepositoryInterface? categoryRepository,
    PostRepositoryInterface? postRepository,
    TimelineUserRepositoryInterface? userRepository,
  })  : categoryRepository = categoryRepository ?? LocalCategoryRepository(),
        postRepository = postRepository ?? LocalPostRepository(),
        userRepository = userRepository ?? LocalTimelineUserRepository();

  final CategoryRepositoryInterface categoryRepository;
  final PostRepositoryInterface postRepository;
  final TimelineUserRepositoryInterface userRepository;

  Stream<List<TimelineCategory>> getCategories() =>
      categoryRepository.getCategories();

  TimelineCategory? selectCategory(String? categoryId) =>
      categoryRepository.selectCategory(categoryId);

  TimelineCategory? getSelectedCategory() =>
      categoryRepository.getSelectedCategory();

  TimelineCategory? getCategory(String? categoryId) =>
      categoryRepository.getCategory(categoryId);

  Future<void> createCategory(TimelineCategory category) =>
      categoryRepository.createCategory(category);

  Stream<List<TimelinePost>> getPosts(String categoryId) =>
      postRepository.getPosts(categoryId);

  Future<void> deletePost(String id) => postRepository.deletePost(id);

  Future<void> likePost(String postId, String userId) =>
      postRepository.likePost(postId, userId);

  Future<void> unlikePost(String postId, String userId) =>
      postRepository.unlikePost(postId, userId);

  Future<List<TimelineUser>> getUsers() => userRepository.getAllUsers();

  Future<TimelineUser> getCurrentUser() => userRepository.getCurrentUser();

  Future<void> likePostReaction(
    TimelinePost post,
    TimelinePostReaction reaction,
    String userId,
  ) =>
      postRepository.likePostReaction(post, reaction, userId);

  Future<void> unlikePostReaction(
    TimelinePost post,
    TimelinePostReaction reaction,
    String userId,
  ) =>
      postRepository.unlikePostReaction(post, reaction, userId);

  Future<void> createReaction(
    TimelinePost post,
    TimelinePostReaction reaction, {
    Uint8List? image,
  }) =>
      postRepository.createReaction(post, reaction, image: image);

  void setCurrentPost(TimelinePost post) => postRepository.setCurrentPost(post);

  TimelinePost getCurrentPost() => postRepository.getCurrentPost();

  Future<void> createPost(TimelinePost post) => postRepository.createPost(post);
}
