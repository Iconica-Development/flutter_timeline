import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_timeline_view/flutter_timeline_view.dart';
import 'package:flutter_timeline_view/src/widgets/category_selector_button.dart';

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
    if (options.categories == null) {
      return const SizedBox.shrink();
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          SizedBox(
            width: options.categorySelectorHorizontalPadding ??
                max(options.padding.horizontal - 4, 0),
          ),
          options.categoryButtonBuilder?.call(
                categoryKey: null,
                categoryName:
                    options.catergoryLabelBuilder?.call(null) ?? 'All',
                onTap: () => onTapCategory(null),
                selected: filter == null,
              ) ??
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: CategorySelectorButton(
                  category: null,
                  selected: filter == null,
                  onTap: () => onTapCategory(null),
                  labelBuilder: options.catergoryLabelBuilder,
                ),
              ),
          for (var category in options.categories!) ...[
            options.categoryButtonBuilder?.call(
                  categoryKey: category,
                  categoryName:
                      options.catergoryLabelBuilder?.call(category) ?? category,
                  onTap: () => onTapCategory(category),
                  selected: filter == category,
                ) ??
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: CategorySelectorButton(
                    category: category,
                    selected: filter == category,
                    onTap: () => onTapCategory(category),
                    labelBuilder: options.catergoryLabelBuilder,
                  ),
                ),
          ],
          SizedBox(
            width: options.categorySelectorHorizontalPadding ??
                max(options.padding.horizontal - 4, 0),
          ),
        ],
      ),
    );
  }
}
