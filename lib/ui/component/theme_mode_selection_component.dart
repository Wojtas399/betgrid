import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../model/user.dart' as user;
import '../extensions/build_context_extensions.dart';
import 'gap/gap_vertical.dart';

class ThemeModeSelection extends StatelessWidget {
  final user.ThemeMode? selectedThemeMode;
  final Function(user.ThemeMode) onThemeModeChanged;

  const ThemeModeSelection({
    super.key,
    this.selectedThemeMode,
    required this.onThemeModeChanged,
  });

  @override
  Widget build(BuildContext context) {
    const gap = GapVertical16();

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _ThemeModeItem(
          isSelected: selectedThemeMode == user.ThemeMode.light,
          label: context.str.lightTheme,
          iconData: Icons.light_mode,
          onPressed: () {
            onThemeModeChanged(user.ThemeMode.light);
          },
        ),
        gap,
        _ThemeModeItem(
          isSelected: selectedThemeMode == user.ThemeMode.dark,
          label: context.str.darkTheme,
          iconData: Icons.dark_mode,
          onPressed: () {
            onThemeModeChanged(user.ThemeMode.dark);
          },
        ),
        gap,
        _ThemeModeItem(
          isSelected: selectedThemeMode == user.ThemeMode.system,
          label: context.str.systemTheme,
          iconData: MdiIcons.themeLightDark,
          onPressed: () {
            onThemeModeChanged(user.ThemeMode.system);
          },
        ),
      ],
    );
  }
}

class _ThemeModeItem extends StatelessWidget {
  final String label;
  final IconData iconData;
  final bool isSelected;
  final VoidCallback onPressed;

  const _ThemeModeItem({
    required this.label,
    required this.iconData,
    required this.isSelected,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) => ListTile(
        onTap: onPressed,
        title: Text(label),
        leading: Icon(iconData),
        contentPadding: const EdgeInsets.only(left: 24, right: 16),
        trailing: Checkbox(
          value: isSelected,
          onChanged: (_) {
            onPressed();
          },
        ),
      );
}
