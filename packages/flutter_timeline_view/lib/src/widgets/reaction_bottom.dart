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
  Widget build(BuildContext context) => Container(
        color: Theme.of(context).colorScheme.background,
        child: Container(
          margin: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 8,
          ),
          height: 45,
          child: widget.messageInputBuilder(
            _textEditingController,
            Padding(
              padding: const EdgeInsets.only(right: 15.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: widget.onPressSelectImage,
                    icon: Icon(
                      Icons.image,
                      color: widget.iconColor,
                    ),
                  ),
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
      );
}
