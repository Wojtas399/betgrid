import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../auth/auth_service.dart';
import '../../../../data/repository/driver/driver_repository.dart';
import '../../../../data/repository/grand_prix/grand_prix_repository.dart';
import '../../../../data/repository/grand_prix_bet/grand_prix_bet_repository.dart';
import '../../../../model/driver.dart';
import '../../../../model/grand_prix.dart';
import '../../../../model/grand_prix_bet.dart';
import '../state/qualifications_bet_state.dart';

part 'qualifications_bet_controller.g.dart';

@riverpod
class QualificationsBetController extends _$QualificationsBetController {
  @override
  Stream<QualificationsBetState> build(String grandPrixId) async* {
    final String? loggedUserId =
        await ref.read(authServiceProvider).loggedUserId$.first;
    if (loggedUserId == null) {
      yield const QualificationsBetStateLoggedUserNotFound();
    } else {
      final String? gpName = await _loadGpName(grandPrixId);
      final List<Driver>? allDrivers =
          await ref.read(driverRepositoryProvider).loadAllDrivers();
      final Stream<QualificationsBetState> listener = _getQualiStandings(
        loggedUserId,
        grandPrixId,
      ).map(
        (List<String>? qualiStandings) => QualificationsBetStateDataLoaded(
          gpName: gpName,
          drivers: allDrivers,
          qualiStandingsByDriverIds: qualiStandings,
        ),
      );
      await for (final state in listener) {
        yield state;
      }
    }
  }

  Future<String?> _loadGpName(String grandPrixId) async {
    final GrandPrix? grandPrix = await ref
        .read(grandPrixRepositoryProvider)
        .loadGrandPrixById(grandPrixId: grandPrixId);
    return grandPrix?.name;
  }

  Stream<List<String>?> _getQualiStandings(
    String loggedUserId,
    String grandPrixId,
  ) =>
      ref
          .read(grandPrixBetRepositoryProvider)
          .getGrandPrixBetByGrandPrixId(
            userId: loggedUserId,
            grandPrixId: grandPrixId,
          )
          .whereNotNull()
          .map((GrandPrixBet bet) => bet.qualiStandingsByDriverIds);
}
