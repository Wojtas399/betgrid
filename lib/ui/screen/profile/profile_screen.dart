import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../dependency_injection.dart';
import '../../../model/user.dart' as user;
import '../../component/gap/gap_vertical.dart';
import '../../component/text_component.dart';
import '../../component/theme_mode_selection_component.dart';
import '../../component/theme_primary_color_selection_component.dart';
import '../../controller/theme_cubit.dart';
import '../../extensions/build_context_extensions.dart';
import 'cubit/profile_cubit.dart';
import 'profile_avatar.dart';
import 'profile_username.dart';

@RoutePage()
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (_) => getIt.get<ProfileCubit>()..initialize(),
        child: Scaffold(
          appBar: AppBar(
            title: Text(context.str.profileScreenTitle),
          ),
          body: const SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GapVertical24(),
                  ProfileAvatar(),
                  GapVertical40(),
                  ProfileUsername(),
                  GapVertical24(),
                  _ThemeMode(),
                  GapVertical24(),
                  _ThemePrimaryColor(),
                  GapVertical64(),
                ],
              ),
            ),
          ),
        ),
      );
}

class _ThemeMode extends StatelessWidget {
  const _ThemeMode();

  void _onThemeModeChanged(user.ThemeMode themeMode, BuildContext context) {
    context.read<ThemeCubit>().changeThemeMode(themeMode);
  }

  @override
  Widget build(BuildContext context) {
    final user.ThemeMode? themeMode = context.select(
      (ThemeCubit cubit) => cubit.state?.themeMode,
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

class _ThemePrimaryColor extends ConsumerWidget {
  const _ThemePrimaryColor();

  void _onPrimaryColorChanged(
    user.ThemePrimaryColor primaryColor,
    BuildContext context,
  ) {
    context.read<ThemeCubit>().changePrimaryColor(primaryColor);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user.ThemePrimaryColor? themePrimaryColor = context.select(
      (ThemeCubit cubit) => cubit.state?.primaryColor,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TitleLarge(
            context.str.color,
            color: context.colorScheme.outline,
          ),
          const GapVertical24(),
          ThemePrimaryColorSelection(
            selectedColor: themePrimaryColor,
            onColorSelected: (user.ThemePrimaryColor color) =>
                _onPrimaryColorChanged(color, context),
          ),
        ],
      ),
    );
  }
}
