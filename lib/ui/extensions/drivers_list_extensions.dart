import '../../model/driver.dart';

extension DriversListExtensions on List<Driver> {
  void sortByTeamAndSurname() => sort(
        (Driver d1, Driver d2) {
          final int teamComparison = d1.team.name.compareTo(d2.team.name);
          return teamComparison != 0
              ? teamComparison
              : d1.surname.compareTo(d2.surname);
        },
      );
}
