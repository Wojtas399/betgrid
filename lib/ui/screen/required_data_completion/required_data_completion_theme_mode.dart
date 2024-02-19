import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../component/gap/gap_vertical.dart';
import '../../component/text/title.dart';
import '../../extensions/build_context_extensions.dart';
import '../../riverpod_provider/theme_notifier_provider.dart';

class RequiredDataCompletionThemeMode extends StatelessWidget {
  const RequiredDataCompletionThemeMode({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: TitleLarge(context.str.theme),
        ),
        const GapVertical16(),
        const _ThemeModeTypes()
      ],
    );
  }
}

class _ThemeModeTypes extends ConsumerWidget {
  const _ThemeModeTypes();

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
