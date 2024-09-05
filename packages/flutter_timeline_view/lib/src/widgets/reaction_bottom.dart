// SPDX-FileCopyrightText: 2023 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_timeline_view/src/config/timeline_options.dart';
import 'package:flutter_timeline_view/src/config/timeline_translations.dart';

class ReactionBottom extends StatefulWidget {
  const ReactionBottom({
    required this.onReactionSubmit,
    required this.messageInputBuilder,
    required this.translations,
    this.iconColor,
    super.key,
  });

  final Future<void> Function(String text) onReactionSubmit;
  final TextInputBuilder messageInputBuilder;
  final TimelineTranslations translations;
  final Color? iconColor;

  @override
  State<ReactionBottom> createState() => _ReactionBottomState();
}

class _ReactionBottomState extends State<ReactionBottom> {
  final TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) => Container(
        child: widget.messageInputBuilder(
          _textEditingController,
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
            ),
            child: IconButton(
              onPressed: () async {
                var value = _textEditingController.text;
                if (value.isNotEmpty) {
                  await widget.onReactionSubmit(value);
                  _textEditingController.clear();
                }
              },
              icon: SvgPicture.asset(
                'assets/send.svg',
                package: 'flutter_timeline_view',
                // ignore: deprecated_member_use
                color: widget.iconColor,
              ),
            ),
          ),
          widget.translations.writeComment,
        ),
      );
}
