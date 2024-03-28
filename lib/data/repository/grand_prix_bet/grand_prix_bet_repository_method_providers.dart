import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../model/grand_prix_bet.dart';
import 'grand_prix_bet_repository.dart';

part 'grand_prix_bet_repository_method_providers.g.dart';

@riverpod
Stream<List<GrandPrixBet>?> allGrandPrixBetsForPlayer(
  AllGrandPrixBetsForPlayerRef ref, {
  required String playerId,
}) =>
    ref
        .watch(grandPrixBetRepositoryProvider)
        .getAllGrandPrixBetsForPlayer(playerId: playerId);
