import "package:cloud_firestore/cloud_firestore.dart";
import "package:collection/collection.dart";
import "package:timeline_repository_interface/timeline_repository_interface.dart";

class FirebaseCategoryRepository implements CategoryRepositoryInterface {
  final CollectionReference categoryCollection =
      FirebaseFirestore.instance.collection("timeline_categories");

  final List<TimelineCategory> _categories = [];
  TimelineCategory? _selectedCategory;

  @override
  Future<void> createCategory(TimelineCategory category) async {
    await categoryCollection.add(category.toJson());
  }

  @override
  Stream<List<TimelineCategory>> getCategories() {
    var currentlySelected = _selectedCategory;

    return categoryCollection
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                (doc) => TimelineCategory.fromJson(
                  doc.data()! as Map<String, dynamic>,
                ),
              )
              .toList(),
        )
        .map((categories) {
      // Ensure that selected category is preserved during re-fetching

      // Modify _categories without resetting selected category
      if (_categories.isEmpty) {
        _categories.add(
          const TimelineCategory(
            key: null,
            title: "All",
          ),
        );
        _categories.addAll(categories);
      } else {
        _categories
          ..clear()
          ..add(const TimelineCategory(key: null, title: "All"))
          ..addAll(categories);
        _selectedCategory = _categories.firstWhereOrNull(
          (category) => category.key == currentlySelected?.key,
        );
      }
      return _categories;
    });
  }

  @override
  TimelineCategory? getCategory(String? categoryId) =>
      _categories.firstWhereOrNull(
        (category) => category.key == categoryId,
      );

  @override
  TimelineCategory? getSelectedCategory() => _selectedCategory;

  @override
  TimelineCategory? selectCategory(String? categoryId) {
    _selectedCategory = _categories.firstWhereOrNull(
      (category) => category.key == categoryId,
    );
    return _selectedCategory;
  }
}
