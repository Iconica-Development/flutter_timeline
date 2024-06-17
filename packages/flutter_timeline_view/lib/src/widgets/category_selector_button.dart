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
  final VoidCallback onTap;
  final TimelineOptions options;
  final bool isOnTop;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var size = MediaQuery.of(context).size;

    return SizedBox(
      height: isOnTop ? 140 : 40,
      child: TextButton(
        onPressed: onTap,
        style: ButtonStyle(
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          padding: const WidgetStatePropertyAll(
            EdgeInsets.symmetric(
              vertical: 5,
              horizontal: 12,
            ),
          ),
          fixedSize: WidgetStatePropertyAll(Size(140, isOnTop ? 140 : 20)),
          backgroundColor: WidgetStatePropertyAll(
            selected
                ? theme.colorScheme.primary
                : options.theme.categorySelectionButtonBackgroundColor ??
                    Colors.transparent,
          ),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: const BorderRadius.all(
                Radius.circular(8),
              ),
              side: BorderSide(
                color: options.theme.categorySelectionButtonBorderColor ??
                    theme.colorScheme.primary,
                width: 2,
              ),
            ),
          ),
        ),
        child: isOnTop
            ? SizedBox(
                width: size.width,
                child: Stack(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _CategoryButtonText(
                          category: category,
                          options: options,
                          theme: theme,
                          selected: selected,
                        ),
                      ],
                    ),
                    Center(child: category.icon),
                  ],
                ),
              )
            : Row(
                children: [
                  Flexible(
                    child: Row(
                      children: [
                        category.icon,
                        SizedBox(
                          width:
                              options.paddings.categoryButtonTextPadding ?? 8,
                        ),
                        Expanded(
                          child: _CategoryButtonText(
                            category: category,
                            options: options,
                            theme: theme,
                            selected: selected,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class _CategoryButtonText extends StatelessWidget {
  const _CategoryButtonText({
    required this.category,
    required this.options,
    required this.theme,
    required this.selected,
    this.overflow,
  });

  final TimelineCategory category;
  final TimelineOptions options;
  final ThemeData theme;
  final bool selected;
  final TextOverflow? overflow;

  @override
  Widget build(BuildContext context) => Text(
        category.title,
        style: (options.theme.textStyles.categoryTitleStyle ??
                theme.textTheme.labelLarge)
            ?.copyWith(
          color: selected
              ? options.theme.categorySelectionButtonSelectedTextColor ??
                  theme.colorScheme.onPrimary
              : options.theme.categorySelectionButtonUnselectedTextColor ??
                  theme.colorScheme.onSurface,
        ),
        textAlign: TextAlign.start,
        overflow: overflow,
      );
}
