import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../component/gap/gap_vertical.dart';
import '../../config/theme/theme_notifier.dart';

class RequiredDataCompletionThemeModeSelection extends ConsumerWidget {
  const RequiredDataCompletionThemeModeSelection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeMode themeMode = ref.watch(themeNotifierProvider);
    final notifier = ref.read(themeNotifierProvider.notifier);
    const gap = GapVertical16();

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _ThemeModeItem(
          isSelected: themeMode == ThemeMode.light,
          label: 'Jasny',
          iconData: Icons.light_mode,
          onPressed: () {
            notifier.changeThemeMode(ThemeMode.light);
          },
        ),
        gap,
        _ThemeModeItem(
          isSelected: themeMode == ThemeMode.dark,
          label: 'Ciemny',
          iconData: Icons.dark_mode,
          onPressed: () {
            notifier.changeThemeMode(ThemeMode.dark);
          },
        ),
        gap,
        _ThemeModeItem(
          isSelected: themeMode == ThemeMode.system,
          label: 'Systemowy',
          iconData: MdiIcons.themeLightDark,
          onPressed: () {
            notifier.changeThemeMode(ThemeMode.system);
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
  Widget build(BuildContext context) {
    return ListTile(
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
}
