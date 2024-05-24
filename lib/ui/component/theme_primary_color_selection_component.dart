import 'package:flutter/material.dart';

import '../../model/user.dart';
import '../extensions/build_context_extensions.dart';
import '../extensions/theme_primary_color_extensions.dart';

class ThemePrimaryColorSelection extends StatelessWidget {
  final ThemePrimaryColor? selectedColor;
  final Function(ThemePrimaryColor) onColorSelected;

  const ThemePrimaryColorSelection({
    super.key,
    this.selectedColor,
    required this.onColorSelected,
  });

  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: ThemePrimaryColor.values
            .map(
              (ThemePrimaryColor color) => _ColorItem(
                isSelected: selectedColor == color,
                color: color.toMaterialColor,
                onPressed: () {
                  onColorSelected(color);
                },
              ),
            )
            .toList(),
      );
}

class _ColorItem extends StatelessWidget {
  final Color color;
  final bool isSelected;
  final VoidCallback onPressed;

  const _ColorItem({
    required this.color,
    required this.isSelected,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) => Transform.scale(
        scale: isSelected ? 1.25 : 1.0,
        child: Container(
          width: 32,
          height: 32,
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: isSelected
                ? Border.all(
                    color: context.colorScheme.onSurface,
                    width: 2.0,
                  )
                : null,
          ),
          child: FilledButton(
            onPressed: onPressed,
            style: FilledButton.styleFrom(
              backgroundColor: color,
            ),
            child: const SizedBox(),
          ),
        ),
      );
}
