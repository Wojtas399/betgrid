import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../../model/grand_prix.dart';
import '../../component/gap/gap_horizontal.dart';
import '../../config/theme/theme_notifier.dart';
import '../../riverpod_provider/all_grand_prixes_provider.dart';
import '../../riverpod_provider/bet_mode_provider.dart';
import 'home_grand_prix_item.dart';
import 'home_timer.dart';

@RoutePage()
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _AppBar(),
      body: const _Body(),
    );
  }
}

class _AppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      scrolledUnderElevation: 0.0,
      title: Text(Str.of(context).homeScreenTitle),
      actions: [
        Icon(
          MdiIcons.themeLightDark,
          color: Theme.of(context).colorScheme.outline,
        ),
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

class _Body extends ConsumerWidget {
  const _Body();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final BetMode betMode = ref.watch(betModeProvider);

    return Column(
      children: [
        if (betMode == BetMode.edit) const HomeTimer(),
        const Expanded(
          child: _GrandPrixes(),
        ),
      ],
    );
  }
}

class _GrandPrixes extends ConsumerWidget {
  const _GrandPrixes();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<GrandPrix>?> allGrandPrixesAsyncVal = ref.watch(
      allGrandPrixesProvider,
    );

    final List<GrandPrix>? allGrandPrixes = allGrandPrixesAsyncVal.value;
    if (allGrandPrixes != null && allGrandPrixes.isNotEmpty) {
      return ListView.builder(
        padding: const EdgeInsets.all(24),
        itemCount: allGrandPrixes.length,
        itemBuilder: (_, int itemIndex) => HomeGrandPrixItem(
          roundNumber: itemIndex + 1,
          grandPrix: allGrandPrixes[itemIndex],
        ),
      );
    }
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}