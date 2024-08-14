import 'package:flutter/material.dart';
import 'package:flutter_timeline_interface/flutter_timeline_interface.dart';
import 'package:flutter_timeline_view/src/config/timeline_options.dart';
import 'package:flutter_timeline_view/src/widgets/default_filled_button.dart';
import 'package:flutter_timeline_view/src/widgets/post_creation_textfield.dart';

class TimelineSelectionScreen extends StatefulWidget {
  const TimelineSelectionScreen({
    required this.options,
    required this.categories,
    required this.onCategorySelected,
    required this.postService,
    super.key,
  });

  final List<TimelineCategory> categories;

  final TimelineOptions options;

  final Function(TimelineCategory) onCategorySelected;

  final TimelinePostService postService;

  @override
  State<TimelineSelectionScreen> createState() =>
      _TimelineSelectionScreenState();
}

class _TimelineSelectionScreenState extends State<TimelineSelectionScreen> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: size.width * 0.05,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20, bottom: 12),
              child: Text(
                widget.options.translations.timelineSelectionDescription,
                style: theme.textTheme.titleLarge,
              ),
            ),
            for (var category in widget.categories.where(
              (element) => element.canCreate && element.key != null,
            )) ...[
              widget.options.categorySelectorButtonBuilder?.call(
                    context,
                    () {
                      widget.onCategorySelected.call(category);
                    },
                    category.title,
                  ) ??
                  InkWell(
                    onTap: () => widget.onCategorySelected.call(category),
                    child: Container(
                      height: 60,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: widget.options.theme
                                  .categorySelectionButtonBorderColor ??
                              Theme.of(context).primaryColor,
                          width: 2,
                        ),
                        color: widget.options.theme
                            .categorySelectionButtonBackgroundColor,
                      ),
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 12.0),
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
            InkWell(
              onTap: showCategoryPopup,
              child: Container(
                height: 60,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: widget
                            .options.theme.categorySelectionButtonBorderColor ??
                        const Color(0xFF9E9E9E),
                    width: 2,
                  ),
                  color: widget
                      .options.theme.categorySelectionButtonBackgroundColor,
                ),
                margin: const EdgeInsets.symmetric(vertical: 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Row(
                        children: [
                          Icon(
                            Icons.add,
                            color: theme.textTheme.titleMedium?.color!
                                .withOpacity(0.5),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            widget.options.translations.addCategoryTitle,
                            style: theme.textTheme.titleMedium!.copyWith(
                              color: theme.textTheme.titleMedium?.color!
                                  .withOpacity(0.5),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> showCategoryPopup() async {
    var theme = Theme.of(context);
    var controller = TextEditingController();
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: theme.scaffoldBackgroundColor,
        insetPadding: const EdgeInsets.symmetric(
          horizontal: 16,
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 50, vertical: 24),
        titlePadding: const EdgeInsets.only(left: 44, right: 44, top: 32),
        title: Text(
          widget.options.translations.createCategoryPopuptitle,
          style: theme.textTheme.titleMedium,
          textAlign: TextAlign.center,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            PostCreationTextfield(
              controller: controller,
              hintText: widget.options.translations.addCategoryHintText,
              validator: (p0) => p0!.isEmpty
                  ? widget.options.translations.addCategoryErrorText
                  : null,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    child: DefaultFilledButton(
                      onPressed: () async {
                        if (controller.text.isEmpty) return;
                        await widget.postService.addCategory(
                          TimelineCategory(
                            key: controller.text,
                            title: controller.text,
                          ),
                        );
                        setState(() {});
                        if (context.mounted) Navigator.pop(context);
                      },
                      buttonText:
                          widget.options.translations.addCategorySubmitButton,
                    ),
                  ),
                ),
              ],
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text(
                widget.options.translations.addCategoryCancelButtton,
                style: theme.textTheme.bodyMedium!.copyWith(
                  decoration: TextDecoration.underline,
                  color: theme.textTheme.bodyMedium?.color!.withOpacity(0.5),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
