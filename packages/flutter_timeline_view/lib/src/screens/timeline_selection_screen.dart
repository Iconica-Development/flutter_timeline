import 'package:flutter/material.dart';
import 'package:flutter_timeline_interface/flutter_timeline_interface.dart';
import 'package:flutter_timeline_view/src/config/timeline_options.dart';

class TimelineSelectionScreen extends StatelessWidget {
  const TimelineSelectionScreen({
    required this.options,
    required this.categories,
    required this.onCategorySelected,
    super.key,
  });

  final List<TimelineCategory> categories;

  final TimelineOptions options;

  final Function(TimelineCategory) onCategorySelected;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: size.width * 0.05,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 20, bottom: 12),
            child: Text(
              options.translations.timelineSelectionDescription,
              style: theme.textTheme.titleLarge,
            ),
          ),
          for (var category in categories.where(
            (element) => element.canCreate && element.key != null,
          )) ...[
            options.categorySelectorButtonBuilder?.call(
                  context,
                  () {
                    onCategorySelected.call(category);
                  },
                  category.title,
                ) ??
                InkWell(
                  onTap: () => onCategorySelected.call(category),
                  child: Container(
                    height: 60,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color:
                            options.theme.categorySelectionButtonBorderColor ??
                                Theme.of(context).primaryColor,
                        width: 2,
                      ),
                      color:
                          options.theme.categorySelectionButtonBackgroundColor,
                    ),
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: Text(
                            category.title,
                            style: theme.textTheme.titleMedium,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
          ],
        ],
      ),
    );
  }
}
