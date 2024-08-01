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
import 'package:flutter_timeline_view/src/widgets/default_filled_button.dart';
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
  bool allowComments = false;
  bool titleIsValid = false;
  bool contentIsValid = false;

  @override
  void initState() {
    titleController.addListener(_listenForInputs);
    contentController.addListener(_listenForInputs);
    super.initState();
  }

  void _listenForInputs() {
    titleIsValid = titleController.text.isNotEmpty;
    contentIsValid = contentController.text.isNotEmpty;
  }

  var formkey = GlobalKey<FormState>();

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
      child: SingleChildScrollView(
        child: Padding(
          padding: widget.options.paddings.mainPadding,
          child: Form(
            key: formkey,
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
                      textCapitalization: TextCapitalization.sentences,
                      expands: null,
                      minLines: null,
                      maxLines: 1,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return widget.options.translations.titleErrorText;
                        }
                        if (value.trim().isEmpty) {
                          return widget.options.translations.titleErrorText;
                        }
                        return null;
                      },
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
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return widget.options.translations.contentErrorText;
                    }
                    if (value.trim().isEmpty) {
                      return widget.options.translations.contentErrorText;
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 16,
                ),
                Text(
                  widget.options.translations.uploadImage,
                  style: theme.textTheme.titleMedium,
                ),
                Text(
                  widget.options.translations.uploadImageDescription,
                  style: theme.textTheme.bodySmall,
                ),
                const SizedBox(
                  height: 8,
                ),
                Stack(
                  children: [
                    GestureDetector(
                      onTap: () async {
                        var result = await showModalBottomSheet<Uint8List?>(
                          context: context,
                          builder: (context) => Container(
                            padding: const EdgeInsets.all(8.0),
                            color: theme.colorScheme.surface,
                            child: ImagePicker(
                              imagePickerConfig:
                                  widget.options.imagePickerConfig,
                              imagePickerTheme: widget
                                      .options.imagePickerTheme ??
                                  ImagePickerTheme(
                                    titleAlignment: TextAlign.center,
                                    title: '    Do you want to upload a file'
                                        ' or take a picture?    ',
                                    titleTextSize:
                                        theme.textTheme.titleMedium!.fontSize!,
                                    font: theme
                                        .textTheme.titleMedium!.fontFamily!,
                                    iconSize: 40,
                                    selectImageText: 'UPLOAD FILE',
                                    makePhotoText: 'TAKE PICTURE',
                                    selectImageIcon: const Icon(
                                      size: 40,
                                      Icons.insert_drive_file,
                                    ),
                                  ),
                              customButton: TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  'Cancel',
                                  style: theme.textTheme.bodyMedium!.copyWith(
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                        if (result != null) {
                          setState(() {
                            image = result;
                          });
                        }
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
                    child: widget.options.buttonBuilder?.call(
                          context,
                          onPostCreated,
                          widget.options.translations.checkPost,
                          enabled: formkey.currentState!.validate(),
                        ) ??
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 48),
                          child: Row(
                            children: [
                              Expanded(
                                child: DefaultFilledButton(
                                  onPressed: titleIsValid && contentIsValid
                                      ? () async {
                                          if (formkey.currentState!
                                              .validate()) {
                                            await onPostCreated();
                                            await widget.service.postService
                                                .fetchPosts(null);
                                          }
                                        }
                                      : null,
                                  buttonText: widget.enablePostOverviewScreen
                                      ? widget.options.translations.checkPost
                                      : widget
                                          .options.translations.postCreation,
                                ),
                              ),
                            ],
                          ),
                        ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
