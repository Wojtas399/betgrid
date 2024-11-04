import '../../model/driver.dart';

extension DriversListExtensions on List<Driver> {
  void sortByTeamAndSurname() => sort(
        (Driver d1, Driver d2) {
          final int teamComparison = d1.teamName.compareTo(d2.teamName);
          return teamComparison != 0
              ? teamComparison
              : d1.surname.compareTo(d2.surname);
        },
      );
}
