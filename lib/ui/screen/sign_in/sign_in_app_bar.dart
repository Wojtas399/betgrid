import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../../../model/user.dart' as user;
import '../../component/gap/gap_horizontal.dart';
import '../../controller/theme_mode_cubit.dart';
import '../../extensions/build_context_extensions.dart';

class SignInAppBar extends StatelessWidget implements PreferredSizeWidget {
  const SignInAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) => AppBar(
        title: Text(Str.of(context).signInScreenTitle),
        actions: [
          Icon(
            MdiIcons.themeLightDark,
            color: context.colorScheme.outline,
          ),
          const GapHorizontal8(),
          const _ThemeSwitch(),
          const GapHorizontal8(),
        ],
      );
}

class _ThemeSwitch extends StatelessWidget {
  const _ThemeSwitch();

  void _onSwitchChanged(bool isSwitched, BuildContext context) {
    context.read<ThemeModeCubit>().changeThemeMode(
          isSwitched ? user.ThemeMode.dark : user.ThemeMode.light,
        );
  }

  @override
  Widget build(BuildContext context) {
    final user.ThemeMode themeMode = context.watch<ThemeModeCubit>().state;

    return Switch(
      value: themeMode == user.ThemeMode.dark,
      onChanged: (bool isSwitched) => _onSwitchChanged(isSwitched, context),
    );
  }
}
