import 'package:betgrid/model/driver.dart';

class DriverCreator {
  final String seasonDriverId;
  final String name;
  final String surname;
  final int number;
  final String teamName;
  final String teamHexColor;

  const DriverCreator({
    this.seasonDriverId = '',
    this.name = '',
    this.surname = '',
    this.number = 0,
    this.teamName = '',
    this.teamHexColor = '',
  });

  Driver create() {
    return Driver(
      seasonDriverId: seasonDriverId,
      name: name,
      surname: surname,
      number: number,
      teamName: teamName,
      teamHexColor: teamHexColor,
    );
  }
}
