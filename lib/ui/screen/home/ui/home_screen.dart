import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../../component/gap/gap_horizontal.dart';
import '../../../component/gap/gap_vertical.dart';
import '../../../config/theme/theme_notifier.dart';
import '../controller/home_controller.dart';
import '../state/home_state.dart';
import 'home_grand_prix_item.dart';

@RoutePage()
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _AppBar(),
      body: const SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: _GrandPrixes(),
        ),
      ),
    );
  }
}

class _AppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(Str.of(context).homeScreenTitle),
      actions: [
        Icon(MdiIcons.themeLightDark, color: Colors.white),
        const GapHorizontal8(),
        const _ThemeModeSwitch(),
        const GapHorizontal8(),
      ],
    );
  }
}

class _ThemeModeSwitch extends ConsumerWidget {
  const _ThemeModeSwitch();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeMode themeMode = ref.watch(themeNotifierProvider);

    return Switch(
      value: themeMode == ThemeMode.dark,
      onChanged: (bool isSwitched) {
        ref.read(themeNotifierProvider.notifier).changeThemeMode(
              isSwitched ? ThemeMode.dark : ThemeMode.light,
            );
      },
    );
  }
}

class _GrandPrixes extends ConsumerWidget {
  const _GrandPrixes();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<HomeState> asyncVal = ref.watch(homeControllerProvider);

    if (asyncVal.hasValue) {
      final HomeState homeState = asyncVal.value!;
      return Column(
        children: [
          if (homeState is HomeStateDataLoaded)
            ...homeState.grandPrixes.map(
              (grandPrix) => HomeGrandPrixItem(grandPrix: grandPrix),
            ),
          const GapVertical64(),
        ],
      );
    }
    return const CircularProgressIndicator();
  }
}
