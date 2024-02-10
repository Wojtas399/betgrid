import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../auth/auth_service.dart';
import '../../../../data/repository/driver/driver_repository.dart';
import '../../../../data/repository/grand_prix_bet/grand_prix_bet_repository.dart';
import '../../../../model/driver.dart';
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
    }
    final Stream<QualificationsBetState> listener = Rx.combineLatest2(
      _getQualiStandings(loggedUserId!, grandPrixId),
      ref.read(driverRepositoryProvider).getAllDrivers().whereNotNull(),
      (
        List<String>? qualiStandingsByDriverIds,
        List<Driver> allDrivers,
      ) =>
          QualificationsBetStateDataLoaded(
        drivers: allDrivers,
        qualiStandingsByDriverIds: qualiStandingsByDriverIds,
      ),
    );
    await for (final state in listener) {
      yield state;
    }
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
