import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../extensions/build_context_extensions.dart';

class SlidableItem extends StatelessWidget {
  const SlidableItem({super.key, required this.child, required this.onDelete});

  final Widget child;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    return Slidable(
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          Theme(
            data: Theme.of(context).copyWith(
              outlinedButtonTheme: OutlinedButtonThemeData(
                style: ButtonStyle(
                  iconColor: WidgetStatePropertyAll(context.colorScheme.error),
                ),
              ),
            ),
            child: SlidableAction(
              onPressed: (context) => onDelete?.call(),
              icon: Icons.delete,
              label: context.str.delete,
              backgroundColor: context.colorScheme.errorContainer,
              foregroundColor: context.colorScheme.error,
            ),
          ),
        ],
      ),
      child: child,
    );
  }
}
