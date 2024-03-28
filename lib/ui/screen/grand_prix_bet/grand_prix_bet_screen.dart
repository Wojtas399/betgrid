import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../provider/grand_prix/grand_prix_id_provider.dart';
import 'grand_prix_bet_app_bar.dart';
import 'grand_prix_bet_body.dart';
import 'provider/player_id_provider.dart';

@RoutePage()
class GrandPrixBetScreen extends StatelessWidget {
  final String grandPrixId;
  final String playerId;

  const GrandPrixBetScreen({
    super.key,
    required this.grandPrixId,
    required this.playerId,
  });

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      overrides: [
        grandPrixIdProvider.overrideWithValue(grandPrixId),
        playerIdProvider.overrideWithValue(playerId),
      ],
      child: const Scaffold(
        appBar: GrandPrixBetAppBar(),
        body: SafeArea(
          child: GrandPrixBetBody(),
        ),
      ),
    );
  }
}
