import 'package:betgrid/model/driver_details.dart';

class DriverDetailsCreator {
  final String seasonDriverId;
  final String name;
  final String surname;
  final int number;
  final String teamName;
  final String teamHexColor;

  const DriverDetailsCreator({
    this.seasonDriverId = '',
    this.name = '',
    this.surname = '',
    this.number = 0,
    this.teamName = '',
    this.teamHexColor = '',
  });

  DriverDetails create() {
    return DriverDetails(
      seasonDriverId: seasonDriverId,
      name: name,
      surname: surname,
      number: number,
      teamName: teamName,
      teamHexColor: teamHexColor,
    );
  }
}
