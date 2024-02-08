import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../model/grand_prix.dart';
import '../../../component/gap/gap_horizontal.dart';
import '../controller/home_controller.dart';
import '../state/home_state.dart';

@RoutePage()
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home screen'),
      ),
      body: const Center(
        child: _GrandPrixes(),
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
              (e) => _GrandPrixItem(grandPrix: e),
            ),
        ],
      );
    }
    return const CircularProgressIndicator();
  }
}

class _GrandPrixItem extends StatelessWidget {
  final GrandPrix grandPrix;

  const _GrandPrixItem({required this.grandPrix});

  String _formatDate(DateTime date) {
    return '${date.year}.${_twoDigits(date.month)}.${_twoDigits(date.day)}';
  }

  String _twoDigits(int number) {
    return number.toString().padLeft(2, '0');
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(grandPrix.name),
        const GapHorizontal16(),
        Text(_formatDate(grandPrix.startDate)),
        const GapHorizontal8(),
        Text(_formatDate(grandPrix.endDate)),
      ],
    );
  }
}
