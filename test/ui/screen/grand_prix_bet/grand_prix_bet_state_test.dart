import 'package:betgrid/model/driver.dart';
import 'package:betgrid/ui/screen/grand_prix_bet/cubit/grand_prix_bet_state.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../creator/driver_creator.dart';

void main() {
  group(
    'getDriveById, ',
    () {
      test(
        'should return null if list of all drivers is null',
        () {
          const state = GrandPrixBetState();

          final Driver? driver = state.getDriverById('d1');

          expect(driver, null);
        },
      );

      test(
        'should return null if list of all drivers is empty',
        () {
          const state = GrandPrixBetState(
            allDrivers: [],
          );

          final Driver? driver = state.getDriverById('d1');

          expect(driver, null);
        },
      );

      test(
        'should return null if driver does not exist in the list of all '
        'drivers',
        () {
          final state = GrandPrixBetState(
            allDrivers: [
              DriverCreator(id: 'd2').createEntity(),
              DriverCreator(id: 'd3').createEntity(),
              DriverCreator(id: 'd4').createEntity(),
            ],
          );

          final Driver? driver = state.getDriverById('d1');

          expect(driver, null);
        },
      );

      test(
        'should return matching driver from the list of all drivers',
        () {
          final state = GrandPrixBetState(
            allDrivers: [
              DriverCreator(id: 'd1').createEntity(),
              DriverCreator(id: 'd2').createEntity(),
              DriverCreator(id: 'd3').createEntity(),
              DriverCreator(id: 'd4').createEntity(),
            ],
          );

          final Driver? driver = state.getDriverById('d1');

          expect(driver, DriverCreator(id: 'd1').createEntity());
        },
      );
    },
  );
}
