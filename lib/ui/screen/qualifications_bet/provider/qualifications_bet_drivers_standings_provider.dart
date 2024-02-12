import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../auth/auth_service.dart';
import '../../../../data/repository/grand_prix_bet/grand_prix_bet_repository.dart';
import '../../../../model/grand_prix_bet.dart';
import '../../../riverpod_provider/grand_prix_id/grand_prix_id_provider.dart';

part 'qualifications_bet_drivers_standings_provider.g.dart';

@Riverpod(dependencies: [grandPrixId])
class QualificationsBetDriversStandings
    extends _$QualificationsBetDriversStandings {
  String? _grandPrixBetId;

  @override
  Stream<List<String?>?> build() {
    final String? grandPrixId = ref.watch(grandPrixIdProvider);
    if (grandPrixId == null) throw 'Grand prix id not found';
    final authService = ref.watch(authServiceProvider);
    final grandPrixBetRepository = ref.watch(grandPrixBetRepositoryProvider);
    return authService.loggedUserId$.switchMap<GrandPrixBet?>(
      (String? loggedUserId) {
        return loggedUserId == null
            ? throw 'Logged user id not found'
            : grandPrixBetRepository.getGrandPrixBetByGrandPrixId(
                userId: loggedUserId,
                grandPrixId: grandPrixId,
              );
      },
    ).map(
      (grandPrixBet) {
        _grandPrixBetId = grandPrixBet?.id;
        return grandPrixBet?.qualiStandingsByDriverIds;
      },
    );
  }

  void onBeginDriversOrdering() {
    state = AsyncData(List.generate(20, (_) => null));
  }

  void onPositionDriverChanged(int position, String driverId) {
    final List<String?> updatedStandings = [...?state.value];
    updatedStandings[position - 1] = driverId;
    state = AsyncData(updatedStandings);
  }

  Future<void> saveStandings() async {
    final authService = ref.read(authServiceProvider);
    final grandPrixBetRepository = ref.read(grandPrixBetRepositoryProvider);
    final String? loggedUserId = await authService.loggedUserId$.first;
    if (loggedUserId == null) {
      throw '[QualificationsBetDriversStandingsProvide] Logged user id not found';
    }
    if (_grandPrixBetId == null) {
      throw '[QualificationsBetDriversStandingsProvide] Grand prix bet id not found';
    }
    await grandPrixBetRepository.updateGrandPrixBet(
      userId: loggedUserId,
      grandPrixBetId: _grandPrixBetId!,
      qualiStandingsByDriverIds: state.value,
    );
  }
}
