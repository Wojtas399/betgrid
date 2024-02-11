import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:rxdart/rxdart.dart';

import '../../../auth/auth_service.dart';
import '../../../data/repository/grand_prix_bet/grand_prix_bet_repository.dart';
import '../../../model/grand_prix_bet.dart';

part 'grand_prix_bet_notifier_provider.g.dart';

@riverpod
class GrandPrixBetNotifier extends _$GrandPrixBetNotifier {
  @override
  Stream<GrandPrixBet?> build(String grandPrixId) {
    final authService = ref.watch(authServiceProvider);
    final grandPrixBetRepository = ref.watch(grandPrixBetRepositoryProvider);
    return authService.loggedUserId$.switchMap<GrandPrixBet?>(
      (String? loggedUserId) => loggedUserId == null
          ? Stream.value(null)
          : grandPrixBetRepository.getGrandPrixBetByGrandPrixId(
              userId: loggedUserId,
              grandPrixId: grandPrixId,
            ),
    );
  }
}
