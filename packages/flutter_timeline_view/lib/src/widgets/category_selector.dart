import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_timeline_view/flutter_timeline_view.dart';

class CategorySelector extends StatefulWidget {
  const CategorySelector({
    required this.filter,
    required this.options,
    required this.onTapCategory,
    required this.isOnTop,
    super.key,
  });

  final String? filter;
  final TimelineOptions options;
  final void Function(String? categoryKey) onTapCategory;
  final bool isOnTop;

  @override
  State<CategorySelector> createState() => _CategorySelectorState();
}

class _CategorySelectorState extends State<CategorySelector> {
  @override
  Widget build(BuildContext context) {
    if (widget.options.categoriesOptions.categoriesBuilder == null) {
      return const SizedBox.shrink();
    }

    var categories =
        widget.options.categoriesOptions.categoriesBuilder!(context);
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          SizedBox(
            width: widget.options.categoriesOptions
                    .categorySelectorHorizontalPadding ??
                max(widget.options.padding.left - 20, 0),
          ),
          for (var category in categories) ...[
            widget.options.categoriesOptions.categoryButtonBuilder?.call(
                  category.key,
                  category.title,
                  () => widget.onTapCategory(category.key),
                  widget.filter == category.key,
                  widget.isOnTop,
                ) ??
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: CategorySelectorButton(
                    isOnTop: widget.isOnTop,
                    category: category,
                    selected: widget.filter == category.key,
                    onTap: () => widget.onTapCategory(category.key),
                    options: widget.options,
                  ),
                ),
          ],
          SizedBox(
            width: widget.options.categoriesOptions
                    .categorySelectorHorizontalPadding ??
                max(widget.options.padding.right - 4, 0),
          ),
        ],
      ),
    );
  }
}
