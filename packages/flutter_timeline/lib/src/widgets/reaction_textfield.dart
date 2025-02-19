import "package:flutter/material.dart";
import "package:flutter_timeline/flutter_timeline.dart";

class ReactionTextfield extends StatelessWidget {
  const ReactionTextfield({
    required this.options,
    required this.controller,
    required this.suffixIcon,
    required this.user,
    super.key,
  });

  final TimelineUser? user;
  final TimelineOptions options;
  final TextEditingController controller;
  final Widget suffixIcon;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return ColoredBox(
      color: theme.scaffoldBackgroundColor,
      child: Padding(
        padding: const EdgeInsets.only(
          left: 12,
          bottom: 20,
          right: 16,
          top: 20,
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: options.userAvatarBuilder(
                user,
                26,
              ),
            ),
            Expanded(
              child: TextField(
                style: theme.textTheme.bodyMedium,
                textCapitalization: TextCapitalization.sentences,
                controller: controller,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: const BorderSide(
                      color: Colors.black,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: const BorderSide(
                      color: Colors.black,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 0,
                    horizontal: 16,
                  ),
                  hintText: options.translations.commentFieldHint,
                  hintStyle: theme.textTheme.bodyMedium!.copyWith(
                    color: theme.textTheme.bodyMedium!.color!
                        .withValues(alpha: 0.5),
                  ),
                  fillColor: Colors.white,
                  filled: true,
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(25),
                    ),
                    borderSide: BorderSide.none,
                  ),
                  suffixIcon: suffixIcon,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
