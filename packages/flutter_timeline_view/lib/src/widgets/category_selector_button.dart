import 'package:flutter/material.dart';
import 'package:flutter_timeline_interface/flutter_timeline_interface.dart';
import 'package:flutter_timeline_view/flutter_timeline_view.dart';

class CategorySelectorButton extends StatelessWidget {
  const CategorySelectorButton({
    required this.category,
    required this.selected,
    required this.onTap,
    required this.options,
    required this.isOnTop,
    super.key,
  });

  final TimelineCategory category;
  final bool selected;
  final void Function() onTap;
  final TimelineOptions options;
  final bool isOnTop;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return AnimatedContainer(
      height: isOnTop ? 140 : 40,
      duration: const Duration(milliseconds: 100),
      child: TextButton(
        onPressed: onTap,
        style: ButtonStyle(
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          padding: const MaterialStatePropertyAll(
            EdgeInsets.symmetric(
              vertical: 5,
              horizontal: 12,
            ),
          ),
          fixedSize: MaterialStatePropertyAll(Size(140, isOnTop ? 140 : 20)),
          backgroundColor: MaterialStatePropertyAll(
            selected ? theme.colorScheme.primary : Colors.transparent,
          ),
          shape: MaterialStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: const BorderRadius.all(
                Radius.circular(8),
              ),
              side: BorderSide(
                color: theme.colorScheme.primary,
                width: 2,
              ),
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Column(
              mainAxisAlignment:
                  isOnTop ? MainAxisAlignment.end : MainAxisAlignment.center,
              children: [
                Text(
                  category.title,
                  style: (options.theme.textStyles.categoryTitleStyle ??
                          theme.textTheme.labelLarge)
                      ?.copyWith(
                    color: selected
                        ? theme.colorScheme.onPrimary
                        : theme.colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
