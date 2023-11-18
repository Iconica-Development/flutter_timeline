// SPDX-FileCopyrightText: 2023 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_image_picker/flutter_image_picker.dart';
import 'package:flutter_timeline_view/src/config/timeline_options.dart';
import 'package:flutter_timeline_view/src/widgets/dotted_container.dart';

class TimelinePostCreationScreen extends StatefulWidget {
  const TimelinePostCreationScreen({
    required this.options,
    this.padding = const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
    super.key,
  });

  /// The options for the timeline
  final TimelineOptions options;

  /// The padding around the screen
  final EdgeInsets padding;

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
      editingDone = titleController.text.isNotEmpty &&
          contentController.text.isNotEmpty &&
          image != null;
    });
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Padding(
      padding: widget.padding,
      child: Column(
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
                      color: Colors.black,
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
                    : CustomPaint(
                        painter: DashedBorderPainter(
                          color: theme.textTheme.displayMedium?.color ??
                              Colors.white,
                          dashLength: 4.0,
                          dashWidth: 1.5,
                          space: 4,
                        ),
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
          const Spacer(),
          Align(
            alignment: Alignment.bottomCenter,
            child: (widget.options.buttonBuilder != null)
                ? widget.options.buttonBuilder!(
                    context,
                    () {},
                    widget.options.translations.checkPost,
                    enabled: editingDone,
                  )
                : ElevatedButton(
                    onPressed: editingDone ? () {} : null,
                    child: Text(
                      widget.options.translations.checkPost,
                      style: theme.textTheme.bodyMedium,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}