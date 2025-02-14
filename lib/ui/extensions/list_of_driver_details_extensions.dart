import '../../model/driver_details.dart';

extension ListOfDriverDetailsExtensions on List<DriverDetails> {
  void sortByTeamAndSurname() => sort((DriverDetails d1, DriverDetails d2) {
    final int teamComparison = d1.teamName.compareTo(d2.teamName);
    return teamComparison != 0
        ? teamComparison
        : d1.surname.compareTo(d2.surname);
  });
}
