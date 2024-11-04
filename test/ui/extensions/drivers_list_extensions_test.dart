import 'package:betgrid/model/driver.dart';
import 'package:betgrid/ui/extensions/drivers_list_extensions.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../creator/driver_creator.dart';

void main() {
  group(
    'sortByTeamAndSurname',
    () {
      test(
        'should sort drivers alphabetically by team',
        () {
          final Driver driver1 = const DriverCreator(
            seasonDriverId: 'sd1',
            teamName: 'Mercedes',
          ).create();
          final Driver driver2 = const DriverCreator(
            seasonDriverId: 'sd2',
            teamName: 'Alpine',
          ).create();
          final List<Driver> originalList = [driver1, driver2];
          final List<Driver> expectedSortedList = [driver2, driver1];

          final List<Driver> sortedList = [...originalList];
          sortedList.sortByTeamAndSurname();

          expect(sortedList, expectedSortedList);
        },
      );

      test(
        'should sort drivers alphabetically by surname if the drivers belong '
        'to the same team',
        () {
          final Driver driver1 = const DriverCreator(
            seasonDriverId: 'sd1',
            teamName: 'Mercedes',
            surname: 'Russel',
          ).create();
          final Driver driver2 = const DriverCreator(
            seasonDriverId: 'sd2',
            teamName: 'Mercedes',
            surname: 'Hamilton',
          ).create();
          final List<Driver> originalList = [driver1, driver2];
          final List<Driver> expectedSortedList = [driver2, driver1];

          final List<Driver> sortedList = [...originalList];
          sortedList.sortByTeamAndSurname();

          expect(sortedList, expectedSortedList);
        },
      );
    },
  );
}
