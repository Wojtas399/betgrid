import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../extensions/build_context_extensions.dart';
import 'text_component.dart';

class ConfirmationDialog extends StatelessWidget {
  final String title;
  final String message;

  const ConfirmationDialog({
    super.key,
    required this.title,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: BodyMedium(message),
      actions: [
        TextButton(
          onPressed: () {
            context.maybePop(false);
          },
          child: BodyMedium(context.str.cancel),
        ),
        TextButton(
          onPressed: () {
            context.maybePop(true);
          },
          child: BodyMedium(
            context.str.delete,
            color: context.colorScheme.error,
          ),
        ),
      ],
    );
  }
}
