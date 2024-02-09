import 'package:betgrid/model/driver.dart';

Driver createDriver({
  String id = '',
  String name = '',
  String surname = '',
  Team team = Team.mercedes,
}) =>
    Driver(
      id: id,
      name: name,
      surname: surname,
      team: team,
    );
