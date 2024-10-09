import "package:flutter/material.dart";
import "package:flutter_timeline/flutter_timeline.dart";
import "package:flutter_timeline/src/widgets/post_info_textfield.dart";
import "package:timeline_repository_interface/timeline_repository_interface.dart";

class TimelineChooseCategoryScreen extends StatelessWidget {
  const TimelineChooseCategoryScreen({
    required this.timelineService,
    required this.ontapCategory,
    required this.options,
    super.key,
  });
  final TimelineService timelineService;
  final Function(TimelineCategory category) ontapCategory;
  final TimelineOptions options;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var newCategoryController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          options.translations.addPost,
          style: theme.textTheme.headlineLarge,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              options.translations.chooseCategory,
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            StreamBuilder(
              stream: timelineService.getCategories(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  var categories = snapshot.data;
                  return Column(
                    children: [
                      ...categories!
                          .where((category) => category.key != null)
                          .map(
                            (category) => CategoryOption(
                              category: category.title,
                              onTap: () {
                                timelineService.selectCategory(category.key);

                                ontapCategory.call(category);
                              },
                            ),
                          ),
                      if (options.allowCreatingCategories)
                        CategoryOption(
                          addCategory: true,
                          category: options.translations.addCategory,
                          onTap: () async {
                            /// shop dialog to add category

                            await showDialog<bool>(
                              context: context,
                              builder: (context) => AlertDialog(
                                backgroundColor: theme.scaffoldBackgroundColor,
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      options.translations.addCategory,
                                      style: theme.textTheme.titleLarge,
                                    ),
                                    const SizedBox(height: 16),
                                    PostInfoTextfield(
                                      controller: newCategoryController,
                                      hintText: "Category...",
                                      validator: (p0) {
                                        if (p0 == null || p0.isEmpty) {
                                          return "Category cannot be empty";
                                        }
                                        return null;
                                      },
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                      ),
                                      child: options.buttonBuilder(
                                        title: options.translations.addCategory,
                                        context: context,
                                        onPressed: () async {
                                          await timelineService.createCategory(
                                            TimelineCategory(
                                              key: newCategoryController.text
                                                  .toLowerCase(),
                                              title: newCategoryController.text,
                                            ),
                                          );
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ),
                                    TextButton(
                                      child: Text(
                                        "Cancel",
                                        style: theme.textTheme.titleMedium,
                                      ),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                    ],
                  );
                }
                return const CircularProgressIndicator();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class CategoryOption extends StatelessWidget {
  const CategoryOption({
    required this.category,
    required this.onTap,
    this.addCategory = false,
    super.key,
  });
  final String category;
  final bool addCategory;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            Expanded(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 2,
                    color: addCategory
                        ? Colors.black.withOpacity(0.3)
                        : theme.primaryColor,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    if (addCategory) ...[
                      const SizedBox(width: 8),
                      Icon(
                        Icons.add,
                        color: addCategory
                            ? Colors.black.withOpacity(0.3)
                            : theme.primaryColor,
                      ),
                    ],
                    Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: addCategory ? 8 : 16,
                      ),
                      child: Text(
                        category,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: addCategory
                              ? Colors.black.withOpacity(0.3)
                              : Colors.black,
                        ),
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
}
