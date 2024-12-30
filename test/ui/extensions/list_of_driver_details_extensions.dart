import 'package:betgrid/model/driver_details.dart';
import 'package:betgrid/ui/extensions/list_of_driver_details_extensions.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../creator/driver_details_creator.dart';

void main() {
  group(
    'sortByTeamAndSurname',
    () {
      test(
        'should sort drivers alphabetically by team',
        () {
          final DriverDetails driver1 = const DriverDetailsCreator(
            seasonDriverId: 'sd1',
            teamName: 'Mercedes',
          ).create();
          final DriverDetails driver2 = const DriverDetailsCreator(
            seasonDriverId: 'sd2',
            teamName: 'Alpine',
          ).create();
          final List<DriverDetails> originalList = [driver1, driver2];
          final List<DriverDetails> expectedSortedList = [driver2, driver1];

          final List<DriverDetails> sortedList = [...originalList];
          sortedList.sortByTeamAndSurname();

          expect(sortedList, expectedSortedList);
        },
      );

      test(
        'should sort drivers alphabetically by surname if the drivers belong '
        'to the same team',
        () {
          final DriverDetails driver1 = const DriverDetailsCreator(
            seasonDriverId: 'sd1',
            teamName: 'Mercedes',
            surname: 'Russel',
          ).create();
          final DriverDetails driver2 = const DriverDetailsCreator(
            seasonDriverId: 'sd2',
            teamName: 'Mercedes',
            surname: 'Hamilton',
          ).create();
          final List<DriverDetails> originalList = [driver1, driver2];
          final List<DriverDetails> expectedSortedList = [driver2, driver1];

          final List<DriverDetails> sortedList = [...originalList];
          sortedList.sortByTeamAndSurname();

          expect(sortedList, expectedSortedList);
        },
      );
    },
  );
}
