import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../model/grand_prix_bet.dart';
import 'grand_prix_bet_repository_impl.dart';

part 'grand_prix_bet_repository.g.dart';

@riverpod
GrandPrixBetRepository grandPrixBetRepository(GrandPrixBetRepositoryRef ref) =>
    GrandPrixBetRepositoryImpl();

abstract interface class GrandPrixBetRepository {
  Future<void> addGrandPrixBets({
    required String userId,
    required List<GrandPrixBet> grandPrixBets,
  });
}
