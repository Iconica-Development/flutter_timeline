import 'package:flutter/material.dart';

class CategorySelectorButton extends StatelessWidget {
  const CategorySelectorButton({
    required this.category,
    required this.selected,
    required this.onTap,
    this.labelBuilder,
    super.key,
  });

  final String? category;
  final bool selected;
  final String Function(String? category)? labelBuilder;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return TextButton(
      onPressed: onTap,
      style: ButtonStyle(
        padding: const MaterialStatePropertyAll(
          EdgeInsets.symmetric(
            vertical: 5,
            horizontal: 12,
          ),
        ),
        minimumSize: const MaterialStatePropertyAll(Size.zero),
        backgroundColor: MaterialStatePropertyAll(
          selected ? theme.colorScheme.primary : theme.colorScheme.surface,
        ),
        shape: const MaterialStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(45),
            ),
          ),
        ),
      ),
      child: Text(
        labelBuilder?.call(category) ?? category ?? 'All',
        style: theme.textTheme.labelMedium?.copyWith(
          color: selected
              ? theme.colorScheme.onPrimary
              : theme.colorScheme.onSurface,
        ),
      ),
    );
  }
}
