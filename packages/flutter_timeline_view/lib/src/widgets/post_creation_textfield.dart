import 'package:flutter/material.dart';

class PostCreationTextfield extends StatelessWidget {
  const PostCreationTextfield({
    required this.controller,
    required this.hintText,
    super.key,
    this.textMaxLength,
    this.decoration,
    this.textCapitalization,
    this.expands,
    this.minLines,
    this.maxLines,
  });

  final TextEditingController controller;
  final String hintText;
  final int? textMaxLength;
  final InputDecoration? decoration;
  final TextCapitalization? textCapitalization;
  // ignore: avoid_positional_boolean_parameters
  final bool? expands;
  final int? minLines;
  final int? maxLines;
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return TextField(
      style: theme.textTheme.bodySmall,
      controller: controller,
      maxLength: textMaxLength,
      decoration: decoration ??
          InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 0,
              horizontal: 16,
            ),
            hintText: hintText,
            hintStyle: theme.textTheme.bodySmall!.copyWith(
              color: theme.textTheme.bodySmall!.color!.withOpacity(0.5),
            ),
            fillColor: Colors.white,
            filled: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
      textCapitalization: textCapitalization ?? TextCapitalization.none,
      expands: expands ?? false,
      minLines: minLines,
      maxLines: maxLines,
    );
  }
}