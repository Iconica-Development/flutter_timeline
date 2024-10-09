import "dart:typed_data";

import "package:flutter/material.dart";
import "package:flutter_timeline/flutter_timeline.dart";
import "package:flutter_timeline/src/widgets/image_picker.dart";
import "package:flutter_timeline/src/widgets/post_info_textfield.dart";
import "package:timeline_repository_interface/timeline_repository_interface.dart";

class TimelineAddPostInformationScreen extends StatefulWidget {
  const TimelineAddPostInformationScreen({
    required this.timelineService,
    required this.onTapOverview,
    required this.options,
    super.key,
  });
  final TimelineService timelineService;
  final void Function() onTapOverview;
  final TimelineOptions options;

  @override
  State<TimelineAddPostInformationScreen> createState() =>
      _TimelineAddPostInformationScreenState();
}

class _TimelineAddPostInformationScreenState
    extends State<TimelineAddPostInformationScreen> {
  final titleController = TextEditingController();
  final contentController = TextEditingController();
  bool allowedToComment = true;
  Uint8List? image;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    var category =
        widget.timelineService.categoryRepository.getSelectedCategory();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          category?.title.toLowerCase() ?? widget.options.translations.addPost,
        ),
      ),
      body: CustomScrollView(
        shrinkWrap: true,
        slivers: [
          SliverList(
            delegate: SliverChildListDelegate([
              Form(
                key: _formKey,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.options.translations.postTitle,
                        style: theme.textTheme.titleMedium,
                      ),
                      PostInfoTextfield(
                        expands: false,
                        maxLines: 1,
                        controller: titleController,
                        hintText: widget.options.translations.postTitleHint,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return widget.options.translations.titleErrorText;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Text(
                        widget.options.translations.contentTitle,
                        style: theme.textTheme.titleMedium,
                      ),
                      Text(
                        widget.options.translations.contentDescription,
                        style: theme.textTheme.bodySmall,
                      ),
                      PostInfoTextfield(
                        expands: false,
                        maxLines: 1,
                        controller: contentController,
                        hintText: widget.options.translations.contentTitleHint,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return widget.options.translations.contentErrorText;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Text(
                        widget.options.translations.uploadimageTitle,
                        style: theme.textTheme.titleMedium,
                      ),
                      Text(
                        widget.options.translations.uploadImageDescription,
                        style: theme.textTheme.bodySmall,
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      ImagePickerWidget(
                        onImageChanged: (pickedImage) {
                          image = pickedImage;
                          setState(() {});
                        },
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      Text(
                        widget.options.translations.allowCommentsTitle,
                        style: theme.textTheme.titleMedium,
                      ),
                      Text(
                        widget.options.translations.allowCommentsDescription,
                        style: theme.textTheme.bodySmall,
                      ),
                      Row(
                        children: [
                          Radio<bool>(
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                            visualDensity: const VisualDensity(horizontal: -4),
                            value: true,
                            groupValue: allowedToComment,
                            onChanged: (value) {
                              setState(() {
                                allowedToComment = true;
                              });
                            },
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Text(widget.options.translations.allowCommentsYes),
                          Radio<bool>(
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                            visualDensity: VisualDensity.standard,
                            value: false,
                            groupValue: allowedToComment,
                            onChanged: (value) {
                              setState(() {
                                allowedToComment = false;
                              });
                            },
                          ),
                          Text(widget.options.translations.allowCommentsNo),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ]),
          ),
          SliverFillRemaining(
            hasScrollBody: false,
            fillOverscroll: false,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                widget.options.buttonBuilder(
                  title: widget.options.translations.overviewButton,
                  onPressed: () async {
                    if (!_formKey.currentState!.validate()) {
                      return;
                    }
                    var user = await widget.timelineService.getCurrentUser();
                    widget.timelineService.setCurrentPost(
                      TimelinePost(
                        id: "",
                        creatorId: user.userId,
                        title: titleController.text,
                        content: contentController.text,
                        image: image,
                        likes: 0,
                        reaction: 0,
                        createdAt: DateTime.now(),
                        reactionEnabled: allowedToComment,
                        category: category?.key,
                        reactions: [],
                        likedBy: [],
                        creator: user,
                      ),
                    );
                    widget.onTapOverview();
                  },
                  context: context,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
