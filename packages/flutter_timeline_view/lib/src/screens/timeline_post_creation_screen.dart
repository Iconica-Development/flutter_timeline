// SPDX-FileCopyrightText: 2023 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause

import 'dart:typed_data';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_picker/flutter_image_picker.dart';
import 'package:flutter_timeline_interface/flutter_timeline_interface.dart';
import 'package:flutter_timeline_view/flutter_timeline_view.dart';
import 'package:flutter_timeline_view/src/config/timeline_options.dart';

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
        id: '',
        creatorId: widget.userId,
        title: titleController.text,
        category: widget.postCategory,
        content: contentController.text,
        likes: 0,
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
        padding: widget.options.padding,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.options.translations.title,
                style: theme.textTheme.displaySmall,
              ),
              widget.options.textInputBuilder?.call(
                    titleController,
                    null,
                    '',
                  ) ??
                  TextField(
                    controller: titleController,
                  ),
              const SizedBox(height: 16),
              Text(
                widget.options.translations.content,
                style: theme.textTheme.displaySmall,
              ),
              const SizedBox(height: 4),
              Text(
                widget.options.translations.contentDescription,
                style: theme.textTheme.bodyMedium,
              ),
              // input field for the content
              SizedBox(
                height: 100,
                child: TextField(
                  controller: contentController,
                  textCapitalization: TextCapitalization.sentences,
                  expands: true,
                  maxLines: null,
                  minLines: null,
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              // input field for the content
              Text(
                widget.options.translations.uploadImage,
                style: theme.textTheme.displaySmall,
              ),
              Text(
                widget.options.translations.uploadImageDescription,
                style: theme.textTheme.bodyMedium,
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
                          color: theme.colorScheme.background,
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
                    child: image != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.memory(
                              image!,
                              width: double.infinity,
                              height: 150.0,
                              fit: BoxFit.cover,
                              // give it a rounded border
                            ),
                          )
                        : DottedBorder(
                            radius: const Radius.circular(8.0),
                            color: theme.textTheme.displayMedium?.color ??
                                Colors.white,
                            child: const SizedBox(
                              width: double.infinity,
                              height: 150.0,
                              child: Icon(
                                Icons.image,
                                size: 32,
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
                style: theme.textTheme.displaySmall,
              ),
              Text(
                widget.options.translations.allowCommentsDescription,
                style: theme.textTheme.bodyMedium,
              ),
              // radio buttons for yes or no
              Switch(
                value: allowComments,
                onChanged: (newValue) {
                  setState(() {
                    allowComments = newValue;
                  });
                },
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: (widget.options.buttonBuilder != null)
                    ? widget.options.buttonBuilder!(
                        context,
                        onPostCreated,
                        widget.options.translations.checkPost,
                        enabled: editingDone,
                      )
                    : ElevatedButton(
                        onPressed: editingDone
                            ? () async {
                                await onPostCreated();
                                await widget.service.postService
                                    .fetchPosts(null);
                              }
                            : null,
                        child: Text(
                          widget.enablePostOverviewScreen
                              ? widget.options.translations.checkPost
                              : widget.options.translations.postCreation,
                          style: theme.textTheme.bodyMedium,
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
