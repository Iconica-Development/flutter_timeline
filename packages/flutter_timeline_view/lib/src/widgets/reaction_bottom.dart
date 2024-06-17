// SPDX-FileCopyrightText: 2023 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause

import 'package:flutter/material.dart';
import 'package:flutter_timeline_view/src/config/timeline_options.dart';
import 'package:flutter_timeline_view/src/config/timeline_translations.dart';

class ReactionBottom extends StatefulWidget {
  const ReactionBottom({
    required this.onReactionSubmit,
    required this.messageInputBuilder,
    required this.translations,
    this.onPressSelectImage,
    this.iconColor,
    super.key,
  });

  final Future<void> Function(String text) onReactionSubmit;
  final TextInputBuilder messageInputBuilder;
  final VoidCallback? onPressSelectImage;
  final TimelineTranslations translations;
  final Color? iconColor;

  @override
  State<ReactionBottom> createState() => _ReactionBottomState();
}

class _ReactionBottomState extends State<ReactionBottom> {
  final TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) => SafeArea(
        bottom: true,
        child: Container(
          color: Theme.of(context).colorScheme.surface,
          child: Container(
            margin: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),
            height: 48,
            child: widget.messageInputBuilder(
              _textEditingController,
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 4,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (widget.onPressSelectImage != null) ...[
                      IconButton(
                        onPressed: () async {
                          _textEditingController.clear();
                          widget.onPressSelectImage?.call();
                        },
                        icon: Icon(
                          Icons.image,
                          color: widget.iconColor,
                        ),
                      ),
                    ],
                    IconButton(
                      onPressed: () async {
                        var value = _textEditingController.text;
                        if (value.isNotEmpty) {
                          await widget.onReactionSubmit(value);
                          _textEditingController.clear();
                        }
                      },
                      icon: Icon(
                        Icons.send,
                        color: widget.iconColor,
                      ),
                    ),
                  ],
                ),
              ),
              widget.translations.writeComment,
            ),
          ),
        ),
      );
}
