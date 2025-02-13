import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../model/user.dart' as user;
import '../../../common_cubit/theme/theme_cubit.dart';
import '../../../component/gap/gap_vertical.dart';
import '../../../component/text_component.dart';
import '../../../component/theme_mode_selection_component.dart';
import '../../../extensions/build_context_extensions.dart';

class ProfileThemeMode extends StatelessWidget {
  const ProfileThemeMode({super.key});

  void _onThemeModeChanged(
    user.ThemeMode themeMode,
    BuildContext context,
  ) {
    context.read<ThemeCubit>().changeThemeMode(themeMode);
  }

  @override
  Widget build(BuildContext context) {
    final user.ThemeMode? themeMode = context.select(
      (ThemeCubit cubit) => cubit.state.themeMode,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: TitleLarge(
            context.str.theme,
            color: context.colorScheme.outline,
          ),
        ),
        const GapVertical16(),
        ThemeModeSelection(
          selectedThemeMode: themeMode,
          onThemeModeChanged: (user.ThemeMode themeMode) =>
              _onThemeModeChanged(themeMode, context),
        ),
      ],
    );
  }
}
