// SPDX-FileCopyrightText: 2023 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause

import 'dart:math';
import 'dart:typed_data';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_picker/flutter_image_picker.dart';
import 'package:flutter_timeline_interface/flutter_timeline_interface.dart';
import 'package:flutter_timeline_view/flutter_timeline_view.dart';
import 'package:flutter_timeline_view/src/config/timeline_options.dart';
import 'package:flutter_timeline_view/src/widgets/post_creation_textfield.dart';

class TimelinePostCreationScreen extends StatefulWidget {
  const TimelinePostCreationScreen({
    required this.userId,
    required this.onPostCreated,
    required this.service,
    required this.options,
    this.postCategory,
    this.onPostOverview,
    this.enablePostOverviewScreen = false,
    super.key,
  });

  final String userId;

  final String? postCategory;

  /// called when the post is created
  final Function(TimelinePost) onPostCreated;

  /// The service to use for creating the post
  final TimelineService service;

  /// The options for the timeline
  final TimelineOptions options;

  /// Nullable callback for routing to the post overview
  final void Function(TimelinePost)? onPostOverview;
  final bool enablePostOverviewScreen;

  @override
  State<TimelinePostCreationScreen> createState() =>
      _TimelinePostCreationScreenState();
}

class _TimelinePostCreationScreenState
    extends State<TimelinePostCreationScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  Uint8List? image;
  bool editingDone = false;
  bool allowComments = false;

  @override
  void initState() {
    super.initState();
    titleController.addListener(checkIfEditingDone);
    contentController.addListener(checkIfEditingDone);
  }

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }

  void checkIfEditingDone() {
    setState(() {
      editingDone =
          titleController.text.isNotEmpty && contentController.text.isNotEmpty;
      if (widget.options.requireImageForPost) {
        editingDone = editingDone && image != null;
      }
      if (widget.options.minTitleLength != null) {
        editingDone = editingDone &&
            titleController.text.length >= widget.options.minTitleLength!;
      }
      if (widget.options.maxTitleLength != null) {
        editingDone = editingDone &&
            titleController.text.length <= widget.options.maxTitleLength!;
      }
      if (widget.options.minContentLength != null) {
        editingDone = editingDone &&
            contentController.text.length >= widget.options.minContentLength!;
      }
      if (widget.options.maxContentLength != null) {
        editingDone = editingDone &&
            contentController.text.length <= widget.options.maxContentLength!;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Future<void> onPostCreated() async {
      var post = TimelinePost(
        id: 'Post${Random().nextInt(1000)}',
        creatorId: widget.userId,
        title: titleController.text,
        category: widget.postCategory,
        content: contentController.text,
        likes: 0,
        likedBy: const [],
        reaction: 0,
        createdAt: DateTime.now(),
        reactionEnabled: allowComments,
        image: image,
      );

      if (widget.enablePostOverviewScreen) {
        widget.onPostOverview?.call(post);
      } else {
        widget.onPostCreated.call(post);
      }
    }

    var theme = Theme.of(context);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Padding(
        padding: widget.options.paddings.mainPadding,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.options.translations.title,
                style: theme.textTheme.titleMedium,
              ),
              const SizedBox(
                height: 4,
              ),
              widget.options.textInputBuilder?.call(
                    titleController,
                    null,
                    '',
                  ) ??
                  PostCreationTextfield(
                    controller: titleController,
                    hintText: widget.options.translations.titleHintText,
                    textMaxLength: widget.options.maxTitleLength,
                    decoration: widget.options.titleInputDecoration,
                    textCapitalization: null,
                    expands: null,
                    minLines: null,
                    maxLines: 1,
                  ),
              const SizedBox(height: 16),
              Text(
                widget.options.translations.content,
                style: theme.textTheme.titleMedium,
              ),
              Text(
                widget.options.translations.contentDescription,
                style: theme.textTheme.bodySmall,
              ),
              const SizedBox(
                height: 4,
              ),
              PostCreationTextfield(
                controller: contentController,
                hintText: widget.options.translations.contentHintText,
                textMaxLength: null,
                decoration: widget.options.contentInputDecoration,
                textCapitalization: TextCapitalization.sentences,
                expands: false,
                minLines: null,
                maxLines: null,
              ),
              const SizedBox(
                height: 16,
              ),
              // input field for the content
              Text(
                widget.options.translations.uploadImage,
                style: theme.textTheme.titleMedium,
              ),
              Text(
                widget.options.translations.uploadImageDescription,
                style: theme.textTheme.bodySmall,
              ),
              // image picker field
              const SizedBox(
                height: 8,
              ),
              Stack(
                children: [
                  GestureDetector(
                    onTap: () async {
                      // open a dialog to choose between camera and gallery
                      var result = await showModalBottomSheet<Uint8List?>(
                        context: context,
                        builder: (context) => Container(
                          padding: const EdgeInsets.all(8.0),
                          color: theme.colorScheme.surface,
                          child: ImagePicker(
                            imagePickerConfig: widget.options.imagePickerConfig,
                            imagePickerTheme: widget.options.imagePickerTheme,
                          ),
                        ),
                      );
                      if (result != null) {
                        setState(() {
                          image = result;
                        });
                      }
                      checkIfEditingDone();
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: image != null
                          ? Image.memory(
                              image!,
                              width: double.infinity,
                              height: 150.0,
                              fit: BoxFit.cover,
                              // give it a rounded border
                            )
                          : DottedBorder(
                              dashPattern: const [4, 4],
                              radius: const Radius.circular(8.0),
                              color: theme.textTheme.displayMedium?.color ??
                                  Colors.white,
                              child: const SizedBox(
                                width: double.infinity,
                                height: 150.0,
                                child: Icon(
                                  Icons.image,
                                  size: 50,
                                ),
                              ),
                            ),
                    ),
                  ),
                  // if an image is selected, show a delete button
                  if (image != null) ...[
                    Positioned(
                      top: 8,
                      right: 8,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            image = null;
                          });
                          checkIfEditingDone();
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: const Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),

              const SizedBox(height: 16),

              Text(
                widget.options.translations.commentsTitle,
                style: theme.textTheme.titleMedium,
              ),
              Text(
                widget.options.translations.allowCommentsDescription,
                style: theme.textTheme.bodySmall,
              ),
              const SizedBox(
                height: 8,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Checkbox(
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    visualDensity:
                        const VisualDensity(horizontal: -4, vertical: -4),
                    activeColor: theme.colorScheme.primary,
                    value: allowComments,
                    onChanged: (value) {
                      setState(() {
                        allowComments = true;
                      });
                    },
                  ),
                  Text(
                    widget.options.translations.yes,
                    style: theme.textTheme.bodyMedium,
                  ),
                  const SizedBox(
                    width: 32,
                  ),
                  Checkbox(
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    visualDensity:
                        const VisualDensity(horizontal: -4, vertical: -4),
                    activeColor: theme.colorScheme.primary,
                    value: !allowComments,
                    onChanged: (value) {
                      setState(() {
                        allowComments = false;
                      });
                    },
                  ),
                  Text(
                    widget.options.translations.no,
                    style: theme.textTheme.bodyMedium,
                  ),
                ],
              ),
              const SizedBox(height: 120),

              SafeArea(
                bottom: true,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: (widget.options.buttonBuilder != null)
                      ? widget.options.buttonBuilder!(
                          context,
                          onPostCreated,
                          widget.options.translations.checkPost,
                          enabled: editingDone,
                        )
                      : FilledButton(
                          style: ButtonStyle(
                            backgroundColor: WidgetStatePropertyAll(
                              theme.colorScheme.primary,
                            ),
                          ),
                          onPressed: editingDone
                              ? () async {
                                  await onPostCreated();
                                  await widget.service.postService
                                      .fetchPosts(null);
                                }
                              : null,
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Text(
                              widget.enablePostOverviewScreen
                                  ? widget.options.translations.checkPost
                                  : widget.options.translations.postCreation,
                              style: theme.textTheme.displayLarge,
                            ),
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
