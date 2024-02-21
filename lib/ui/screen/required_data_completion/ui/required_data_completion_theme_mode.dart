import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../model/user.dart' as user;
import '../../../component/gap/gap_vertical.dart';
import '../../../component/text/title.dart';
import '../../../component/theme_mode_selection_component.dart';
import '../../../extensions/build_context_extensions.dart';
import '../../../provider/theme_mode_notifier_provider.dart';

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
    final AsyncValue<user.ThemeMode> themeMode = ref.watch(
      themeModeNotifierProvider,
    );

    return ThemeModeSelection(
      selectedThemeMode: themeMode.value,
      onThemeModeChanged: (user.ThemeMode themeMode) {
        ref.read(themeModeNotifierProvider.notifier).changeThemeMode(themeMode);
      },
    );
  }
}
