import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../model/grand_prix.dart';
import '../../../riverpod_provider/grand_prix/grand_prix_provider.dart';
import 'qualifications_bet_drivers_standings.dart';

@RoutePage()
class QualificationsBetScreen extends StatelessWidget {
  final String? grandPrixId;

  const QualificationsBetScreen({
    super.key,
    @PathParam('grandPrixId') this.grandPrixId,
  });

  @override
  Widget build(BuildContext context) {
    if (grandPrixId == null) {
      return const Text('Page not found');
    }

    return Scaffold(
      appBar: _AppBar(grandPrixId: grandPrixId!),
      body: SafeArea(
        child: QualificationsBetDriversStandings(grandPrixId: grandPrixId!),
      ),
    );
  }
}

class _AppBar extends ConsumerWidget implements PreferredSizeWidget {
  final String grandPrixId;

  const _AppBar({required this.grandPrixId});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String? grandPrixName = ref.watch(
      grandPrixProvider(grandPrixId).select(
        (AsyncValue<GrandPrix?> asyncVal) => asyncVal.value?.name,
      ),
    );

    return AppBar(
      title: Text('$grandPrixName - kwalifikacje'),
    );
  }
}
