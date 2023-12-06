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
            padding: EdgeInsets.only(top: size.height * 0.05, bottom: 8),
            child: Text(
              options.translations.timelineSelectionDescription,
              style:
                  options.theme.textStyles.categorySelectionDescriptionStyle ??
                      theme.textTheme.displayMedium,
            ),
          ),
          const SizedBox(height: 4),
          for (var category in categories.where(
            (element) => element.canCreate,
          )) ...[
            InkWell(
              onTap: () => onCategorySelected.call(category),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: 26,
                  horizontal: 16,
                ),
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  category.title,
                  style: options.theme.textStyles.categorySelectionTitleStyle ??
                      theme.textTheme.displaySmall,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
