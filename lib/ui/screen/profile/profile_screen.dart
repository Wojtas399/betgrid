import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../model/user.dart' as user;
import '../../component/gap/gap_vertical.dart';
import '../../component/text/title.dart';
import '../../component/theme_mode_selection_component.dart';
import '../../component/theme_primary_color_selection_component.dart';
import '../../extensions/build_context_extensions.dart';
import '../../provider/logged_user_data_provider.dart';
import 'profile_avatar.dart';
import 'profile_username.dart';

@RoutePage()
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
    );
  }
}

class _ThemeMode extends ConsumerWidget {
  const _ThemeMode();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user.ThemeMode? themeMode = ref.watch(
      loggedUserDataProvider.select(
        (AsyncValue<user.User?> loggedUserData) =>
            loggedUserData.value?.themeMode,
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: TitleLarge(
            context.str.theme,
            color: Theme.of(context).colorScheme.outline,
          ),
        ),
        const GapVertical16(),
        ThemeModeSelection(
          selectedThemeMode: themeMode,
          onThemeModeChanged: (user.ThemeMode themeMode) {
            //TODO
          },
        ),
      ],
    );
  }
}

class _ThemePrimaryColor extends ConsumerWidget {
  const _ThemePrimaryColor();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user.ThemePrimaryColor? themePrimaryColor = ref.watch(
      loggedUserDataProvider.select(
        (AsyncValue<user.User?> loggedUserData) =>
            loggedUserData.value?.themePrimaryColor,
      ),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TitleLarge(
            context.str.color,
            color: Theme.of(context).colorScheme.outline,
          ),
          const GapVertical24(),
          ThemePrimaryColorSelection(
            selectedColor: themePrimaryColor,
            onColorSelected: (user.ThemePrimaryColor color) {
              //TODO
            },
          ),
        ],
      ),
    );
  }
}
