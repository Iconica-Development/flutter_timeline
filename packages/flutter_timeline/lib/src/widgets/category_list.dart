import "package:flutter/material.dart";
import "package:flutter_timeline/src/widgets/category_widget.dart";
import "package:timeline_repository_interface/timeline_repository_interface.dart";
import "package:collection/collection.dart";

class CategoryList extends StatefulWidget {
  const CategoryList({
    required this.categories,
    required this.onTap,
    required this.isOnTop,
    required this.selectedCategory,
    super.key,
  });

  final List<TimelineCategory> categories;
  final Function(TimelineCategory) onTap;
  final bool isOnTop;
  final TimelineCategory? selectedCategory;

  @override
  State<CategoryList> createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  TimelineCategory? selectedCategory;

  @override
  void initState() {
    selectedCategory = widget.selectedCategory ?? widget.categories.firstOrNull;
    super.initState();
  }

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              for (var i = 0; i < widget.categories.length; i++)
                CategoryWidget(
                  category: widget.categories[i],
                  onTap: (category) {
                    widget.onTap(category);
                    setState(() {
                      selectedCategory = category;
                    });
                  },
                  isOnTop: widget.isOnTop,
                  selected: selectedCategory?.key == widget.categories[i].key,
                ),
            ],
          ),
        ),
      );
}
