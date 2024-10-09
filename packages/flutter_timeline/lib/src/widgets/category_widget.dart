import "package:flutter/material.dart";
import "package:timeline_repository_interface/timeline_repository_interface.dart";

class CategoryWidget extends StatelessWidget {
  const CategoryWidget({
    required this.category,
    required this.onTap,
    required this.isOnTop,
    required this.selected,
    super.key,
  });

  final TimelineCategory category;
  final Function(TimelineCategory) onTap;
  final bool isOnTop;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return InkWell(
      onTap: () => onTap(category),
      child: AnimatedCrossFade(
        crossFadeState:
            isOnTop ? CrossFadeState.showFirst : CrossFadeState.showSecond,
        duration: const Duration(milliseconds: 100),
        firstChild: ExpandedCategoryWidget(
          selected: selected,
          theme: theme,
          category: category,
        ),
        secondChild: CollapsedCategoryWidget(
          selected: selected,
          theme: theme,
          category: category,
        ),
      ),
    );
  }
}

class CollapsedCategoryWidget extends StatelessWidget {
  const CollapsedCategoryWidget({
    required this.selected,
    required this.theme,
    required this.category,
    super.key,
  });

  final bool selected;
  final ThemeData theme;
  final TimelineCategory category;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(right: 8),
        child: Container(
          decoration: BoxDecoration(
            color: selected ? theme.primaryColor : theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: theme.primaryColor,
              width: 2,
            ),
          ),
          width: 140,
          height: 40,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Text(
                maxLines: 1,
                category.title,
                style: selected
                    ? theme.textTheme.titleMedium
                    : theme.textTheme.bodyMedium?.copyWith(
                        color: selected
                            ? theme.colorScheme.onPrimary
                            : theme.colorScheme.onSurface,
                      ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ),
      );
}

class ExpandedCategoryWidget extends StatelessWidget {
  const ExpandedCategoryWidget({
    required this.selected,
    required this.theme,
    required this.category,
    super.key,
  });

  final bool selected;
  final ThemeData theme;
  final TimelineCategory category;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(right: 8),
        child: Container(
          decoration: BoxDecoration(
            color: selected ? theme.primaryColor : theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: theme.primaryColor,
              width: 2,
            ),
          ),
          width: 140,
          height: 140,
          child: Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                category.title,
                style: selected
                    ? theme.textTheme.titleMedium
                    : theme.textTheme.bodyMedium?.copyWith(
                        color: selected
                            ? theme.colorScheme.onPrimary
                            : theme.colorScheme.onSurface,
                      ),
              ),
            ),
          ),
        ),
      );
}
