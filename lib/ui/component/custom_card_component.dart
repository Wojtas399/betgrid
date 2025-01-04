import 'package:flutter/material.dart';

import '../extensions/build_context_extensions.dart';
import 'padding/padding_components.dart';

class CustomCard extends StatelessWidget {
  final Widget child;
  final VoidCallback onPressed;

  const CustomCard({
    super.key,
    required this.child,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) => SizedBox(
        width: double.infinity,
        child: Card(
          color: context.colorScheme.surfaceContainer,
          shape: RoundedRectangleBorder(
            side: BorderSide(
              color: context.colorScheme.surfaceContainerHighest,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          clipBehavior: Clip.hardEdge,
          child: InkWell(
            onTap: onPressed,
            child: Padding16(
              child: child,
            ),
          ),
        ),
      );
}
