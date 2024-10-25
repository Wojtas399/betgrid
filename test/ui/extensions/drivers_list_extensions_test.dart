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
            id: 'd1',
            team: DriverCreatorTeam.mercedes,
          ).createEntity();
          final Driver driver2 = const DriverCreator(
            id: 'd2',
            team: DriverCreatorTeam.alpine,
          ).createEntity();
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
            id: 'd1',
            team: DriverCreatorTeam.mercedes,
            surname: 'Russel',
          ).createEntity();
          final Driver driver2 = const DriverCreator(
            id: 'd2',
            team: DriverCreatorTeam.mercedes,
            surname: 'Hamilton',
          ).createEntity();
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
