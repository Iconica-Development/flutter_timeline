import 'package:flutter/material.dart';

class DefaultFilledButton extends StatelessWidget {
  const DefaultFilledButton({
    required this.onPressed,
    required this.buttonText,
    super.key,
  });

  final Future<void> Function()? onPressed;
  final String buttonText;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return FilledButton(
      style: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(
          theme.colorScheme.primary,
        ),
      ),
      onPressed: onPressed,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Text(
          buttonText,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.displayLarge,
        ),
      ),
    );
  }
}
