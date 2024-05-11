import 'package:betgrid/model/driver.dart';
import 'package:betgrid/ui/screen/grand_prix_bet/cubit/grand_prix_bet_state.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../creator/driver_creator.dart';

void main() {
  test(
    'getDriverById, '
    'list of all drivers is null, '
    'should return null',
    () {
      const state = GrandPrixBetState();

      final Driver? driver = state.getDriverById('d1');

      expect(driver, null);
    },
  );

  test(
    'getDriverById, '
    'list of all drivers is empty, '
    'should return null',
    () {
      const state = GrandPrixBetState(
        allDrivers: [],
      );

      final Driver? driver = state.getDriverById('d1');

      expect(driver, null);
    },
  );

  test(
    'getDriverById, '
    'driver does not exist in the list of all drivers, '
    'should return null',
    () {
      final state = GrandPrixBetState(
        allDrivers: [
          createDriver(id: 'd2'),
          createDriver(id: 'd3'),
          createDriver(id: 'd4'),
        ],
      );

      final Driver? driver = state.getDriverById('d1');

      expect(driver, null);
    },
  );

  test(
    'getDriverById, '
    'should return matching driver from the list of all drivers',
    () {
      final state = GrandPrixBetState(
        allDrivers: [
          createDriver(id: 'd1'),
          createDriver(id: 'd2'),
          createDriver(id: 'd3'),
          createDriver(id: 'd4'),
        ],
      );

      final Driver? driver = state.getDriverById('d1');

      expect(driver, createDriver(id: 'd1'));
    },
  );
}
