import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../model/user.dart';
import '../../../component/gap/gap_vertical.dart';
import '../../../component/text/title.dart';
import '../../../component/theme_primary_color_selection_component.dart';
import '../../../extensions/build_context_extensions.dart';
import '../../../provider/theme/theme_primary_color_notifier_provider.dart';

class RequiredDataCompletionThemeColor extends StatelessWidget {
  const RequiredDataCompletionThemeColor({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TitleLarge(context.str.color),
          const GapVertical16(),
          const _Colors(),
        ],
      ),
    );
  }
}

class _Colors extends ConsumerWidget {
  const _Colors();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<ThemePrimaryColor> selectedThemePrimaryColor = ref.watch(
      themePrimaryColorNotifierProvider,
    );

    return ThemePrimaryColorSelection(
      selectedColor: selectedThemePrimaryColor.value,
      onColorSelected: (ThemePrimaryColor color) {
        ref
            .read(themePrimaryColorNotifierProvider.notifier)
            .changeThemePrimaryColor(color);
      },
    );
  }
}
