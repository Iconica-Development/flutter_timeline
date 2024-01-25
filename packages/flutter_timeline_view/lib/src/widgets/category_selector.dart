import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_timeline_view/flutter_timeline_view.dart';

class CategorySelector extends StatelessWidget {
  const CategorySelector({
    required this.filter,
    required this.options,
    required this.onTapCategory,
    super.key,
  });

  final String? filter;
  final TimelineOptions options;
  final void Function(String? categoryKey) onTapCategory;

  @override
  Widget build(BuildContext context) {
    if (options.categoriesOptions.categoriesBuilder == null) {
      return const SizedBox.shrink();
    }

    var categories = options.categoriesOptions.categoriesBuilder!(context);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          SizedBox(
            width:
                options.categoriesOptions.categorySelectorHorizontalPadding ??
                    max(options.padding.horizontal - 4, 0),
          ),
          for (var category in categories) ...[
            options.categoriesOptions.categoryButtonBuilder?.call(
                  categoryKey: category.key,
                  categoryName: category.title,
                  onTap: () => onTapCategory(category.key),
                  selected: filter == category.key,
                ) ??
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: CategorySelectorButton(
                    category: category,
                    selected: filter == category.key,
                    onTap: () => onTapCategory(category.key),
                  ),
                ),
          ],
          SizedBox(
            width:
                options.categoriesOptions.categorySelectorHorizontalPadding ??
                    max(options.padding.horizontal - 4, 0),
          ),
        ],
      ),
    );
  }
}
