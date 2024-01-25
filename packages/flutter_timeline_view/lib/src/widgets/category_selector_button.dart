import 'package:flutter/material.dart';
import 'package:flutter_timeline_interface/flutter_timeline_interface.dart';

class CategorySelectorButton extends StatelessWidget {
  const CategorySelectorButton({
    required this.category,
    required this.selected,
    required this.onTap,
    super.key,
  });

  final TimelineCategory category;
  final bool selected;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return TextButton(
      onPressed: onTap,
      style: ButtonStyle(
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
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
        category.title,
        style: theme.textTheme.labelMedium?.copyWith(
          color: selected
              ? theme.colorScheme.onPrimary
              : theme.colorScheme.onSurface,
        ),
      ),
    );
  }
}
