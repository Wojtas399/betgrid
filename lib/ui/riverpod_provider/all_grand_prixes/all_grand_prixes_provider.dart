import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../auth/auth_service.dart';
import '../../../../data/repository/grand_prix/grand_prix_repository.dart';
import '../../../../data/repository/grand_prix_bet/grand_prix_bet_repository.dart';
import '../../../../model/grand_prix.dart';
import '../../../../model/grand_prix_bet.dart';

part 'all_grand_prixes_provider.g.dart';

@riverpod
Future<List<GrandPrix>?> allGrandPrixes(AllGrandPrixesRef ref) async {
  final String? loggedUserId =
      await ref.read(authServiceProvider).loggedUserId$.first;
  if (loggedUserId == null) return null;
  final List<GrandPrix> grandPrixes =
      await ref.read(grandPrixRepositoryProvider).loadAllGrandPrixes();
  grandPrixes.sort(
    (GrandPrix gp1, GrandPrix gp2) => gp1.startDate.compareTo(gp2.startDate),
  );
  await _initializeBetsIfNeeded(loggedUserId, grandPrixes, ref);
  return grandPrixes;
}

Future<void> _initializeBetsIfNeeded(
  String loggedUserId,
  List<GrandPrix> grandPrixes,
  AllGrandPrixesRef ref,
) async {
  final Stream<List<GrandPrixBet>?> bets$ = ref
      .read(grandPrixBetRepositoryProvider)
      .getAllGrandPrixBets(userId: loggedUserId);
  await for (final bets in bets$) {
    if (bets == null || bets.isEmpty) {
      await ref.read(grandPrixBetRepositoryProvider).addGrandPrixBets(
            userId: loggedUserId,
            grandPrixBets: grandPrixes
                .map(
                  (GrandPrix gp) => GrandPrixBet(id: '', grandPrixId: gp.id),
                )
                .toList(),
          );
    }
    return;
  }
}
