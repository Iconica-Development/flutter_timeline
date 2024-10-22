import "package:timeline_repository_interface/src/models/timeline_category.dart";

abstract class CategoryRepositoryInterface {
  // everything is done with streams
  Stream<List<TimelineCategory>> getCategories();
  Future<void> createCategory(TimelineCategory category);
  TimelineCategory? selectCategory(String? categoryId);
  TimelineCategory? getSelectedCategory();
  TimelineCategory? getCategory(String? categoryId);
}
