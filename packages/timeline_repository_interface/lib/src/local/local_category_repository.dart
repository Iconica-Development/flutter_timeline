import "package:timeline_repository_interface/timeline_repository_interface.dart";

class LocalCategoryRepository implements CategoryRepositoryInterface {
  final List<TimelineCategory> _categories = [
    const TimelineCategory(key: null, title: "All"),
    const TimelineCategory(key: "1", title: "Category"),
    const TimelineCategory(key: "2", title: "Category with two lines"),
  ];

  TimelineCategory? _selectedCategory;

  @override
  Future<void> createCategory(TimelineCategory category) async{
    _categories.add(category);
  }

  @override
  Stream<List<TimelineCategory>> getCategories() => Stream.value(_categories);

  @override
  TimelineCategory selectCategory(String? categoryId) {
    _selectedCategory = _categories.firstWhere(
      (category) => category.key == categoryId,
      orElse: () => _categories.first,
    );
    return _selectedCategory!;
  }

  @override
  TimelineCategory? getSelectedCategory() => _selectedCategory;

  @override
  TimelineCategory? getCategory(String? categoryId) => _categories.firstWhere(
        (category) => category.key == categoryId,
        orElse: () => _categories.first,
      );
}
