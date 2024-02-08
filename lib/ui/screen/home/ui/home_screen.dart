import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../component/gap/gap_vertical.dart';
import '../controller/home_controller.dart';
import '../state/home_state.dart';
import 'grand_prix_item.dart';

@RoutePage()
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('2024 season'),
      ),
      body: const SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: _GrandPrixes(),
        ),
      ),
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
              (e) => GrandPrixItem(grandPrix: e),
            ),
          const GapVertical64(),
        ],
      );
    }
    return const CircularProgressIndicator();
  }
}
