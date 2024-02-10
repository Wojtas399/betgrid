import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../extensions/build_context_extensions.dart';
import '../controller/qualifications_bet_controller.dart';
import '../state/qualifications_bet_state.dart';

@RoutePage()
class QualificationsBetScreen extends StatelessWidget {
  final String? grandPrixId;

  const QualificationsBetScreen({
    super.key,
    @PathParam('grandPrixId') this.grandPrixId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.str.qualifications),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: grandPrixId != null
              ? _DriversList(grandPrixId: grandPrixId!)
              : const Text('Not found'),
        ),
      ),
    );
  }
}

class _DriversList extends ConsumerWidget {
  final String grandPrixId;

  const _DriversList({required this.grandPrixId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<QualificationsBetState> asyncState = ref.watch(
      qualificationsBetControllerProvider(grandPrixId),
    );

    final QualificationsBetState? state = asyncState.value;
    if (state != null && state is QualificationsBetStateDataLoaded) {
      return Column(
        children: [
          ...state.drivers.map(
            (driver) => Text('${driver.name} ${driver.surname}'),
          ),
        ],
      );
    }
    return const CircularProgressIndicator();
  }
}
