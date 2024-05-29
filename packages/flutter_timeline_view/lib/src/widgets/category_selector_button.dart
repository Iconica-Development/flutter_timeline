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

    return SizedBox(
      height: isOnTop ? 140 : 40,
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
            selected
                ? theme.colorScheme.primary
                : options.theme.categorySelectionButtonBackgroundColor ??
                    Colors.transparent,
          ),
          shape: MaterialStatePropertyAll(
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
                width: MediaQuery.of(context).size.width,
                child: Stack(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                          textAlign: TextAlign.start,
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
                          child: Text(
                            category.title,
                            style:
                                (options.theme.textStyles.categoryTitleStyle ??
                                        theme.textTheme.labelLarge)
                                    ?.copyWith(
                              color: selected
                                  ? theme.colorScheme.onPrimary
                                  : theme.colorScheme.onSurface,
                            ),
                            textAlign: TextAlign.start,
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
