import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../model/grand_prix.dart';
import '../../../model/user.dart' as user;
import '../../provider/all_grand_prixes_provider.dart';
import '../../provider/bet_mode_provider.dart';
import '../../provider/logged_user_data_notifier_provider.dart';
import '../../service/dialog_service.dart';
import '../required_data_completion/ui/required_data_completion_screen.dart';
import 'home_app_bar.dart';
import 'home_grand_prix_item.dart';
import 'home_timer.dart';

@RoutePage()
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  void _onLoggedUserDataChanged(AsyncValue<user.User?> asyncValue) async {
    if (asyncValue is AsyncData && asyncValue.value == null) {
      await showFullScreenDialog(const RequiredDataCompletionScreen());
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(
      loggedUserDataNotifierProvider,
      (previous, next) {
        _onLoggedUserDataChanged(next);
      },
    );

    return const Scaffold(
      appBar: HomeAppBar(),
      body: _Body(),
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
