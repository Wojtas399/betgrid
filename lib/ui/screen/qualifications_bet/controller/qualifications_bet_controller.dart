import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../data/repository/driver/driver_repository.dart';
import '../../../../model/driver.dart';
import '../state/qualifications_bet_state.dart';

part 'qualifications_bet_controller.g.dart';

@riverpod
class QualificationsBetController extends _$QualificationsBetController {
  @override
  Stream<QualificationsBetState> build() async* {
    final Stream<List<Driver>?> drivers$ =
        ref.read(driverRepositoryProvider).getAllDrivers();
    await for (final drivers in drivers$) {
      if (drivers != null) {
        yield QualificationsBetStateDataLoaded(drivers: drivers);
      }
    }
  }
}
