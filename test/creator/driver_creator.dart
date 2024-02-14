import 'package:betgrid/model/driver.dart';

Driver createDriver({
  String id = '',
  String name = '',
  String surname = '',
  int number = 1,
  Team team = Team.mercedes,
}) =>
    Driver(
      id: id,
      name: name,
      surname: surname,
      number: number,
      team: team,
    );
