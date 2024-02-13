import 'package:collection/collection.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:rxdart/rxdart.dart';

import '../../auth/auth_service.dart';
import '../../data/repository/grand_prix_bet/grand_prix_bet_repository.dart';
import '../../model/grand_prix_bet.dart';

part 'grand_prix_bet_status_provider.g.dart';

enum GrandPrixBetStatus {
  pending,
  inProgress,
  completed,
}

@riverpod
Stream<GrandPrixBetStatus?> grandPrixBetStatus(
  GrandPrixBetStatusRef ref,
  String grandPrixId,
) async* {
  final Stream<GrandPrixBet?> bet$ =
      ref.watch(authServiceProvider).loggedUserId$.switchMap(
            (String? loggedUserId) => loggedUserId != null
                ? ref
                    .watch(grandPrixBetRepositoryProvider)
                    .getGrandPrixBetByGrandPrixId(
                      userId: loggedUserId,
                      grandPrixId: grandPrixId,
                    )
                : throw '[GrandPrixBetStatusProvider] Logged user not found',
          );
  await for (final bet in bet$) {
    if (bet == null) {
      yield null;
    } else if (_isBetPending(bet)) {
      yield GrandPrixBetStatus.pending;
    } else if (_isBetCompleted(bet)) {
      yield GrandPrixBetStatus.completed;
    } else {
      yield GrandPrixBetStatus.inProgress;
    }
  }
}

bool _isBetCompleted(GrandPrixBet bet) =>
    !bet.qualiStandingsByDriverIds.containsNull &&
    bet.p1DriverId != null &&
    bet.p2DriverId != null &&
    bet.p3DriverId != null &&
    bet.p10DriverId != null &&
    bet.fastestLapDriverId != null &&
    !bet.dnfDriverIds.containsNull &&
    bet.willBeSafetyCar != null &&
    bet.willBeRedFlag != null;

bool _isBetPending(GrandPrixBet bet) =>
    bet.qualiStandingsByDriverIds.containsOnlyNull &&
    bet.p1DriverId == null &&
    bet.p2DriverId == null &&
    bet.p3DriverId == null &&
    bet.p10DriverId == null &&
    bet.fastestLapDriverId == null &&
    bet.dnfDriverIds.containsOnlyNull &&
    bet.willBeSafetyCar == null &&
    bet.willBeRedFlag == null;

extension _StringListExtensions on List<String?> {
  bool get containsNull {
    for (final element in this) {
      if (element == null) return true;
    }
    return false;
  }

  bool get containsOnlyNull => firstWhereOrNull((el) => el != null) == null;
}
