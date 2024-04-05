import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../model/grand_prix_bet.dart';
import 'grand_prix_bet_repository_impl.dart';

part 'grand_prix_bet_repository.g.dart';

abstract interface class GrandPrixBetRepository {
  Stream<List<GrandPrixBet>?> getAllGrandPrixBetsForPlayer({
    required String playerId,
  });

  Stream<GrandPrixBet?> getBetByGrandPrixIdAndPlayerId({
    required String playerId,
    required String grandPrixId,
  });

  Future<void> addGrandPrixBets({
    required String playerId,
    required List<GrandPrixBet> grandPrixBets,
  });

  Future<void> updateGrandPrixBet({
    required String playerId,
    required String grandPrixBetId,
    List<String?>? qualiStandingsByDriverIds,
    String? p1DriverId,
    String? p2DriverId,
    String? p3DriverId,
    String? p10DriverId,
    String? fastestLapDriverId,
    List<String?>? dnfDriverIds,
    bool? willBeSafetyCar,
    bool? willBeRedFlag,
  });
}

@Riverpod(keepAlive: true)
GrandPrixBetRepository grandPrixBetRepository(GrandPrixBetRepositoryRef ref) =>
    GrandPrixBetRepositoryImpl();
