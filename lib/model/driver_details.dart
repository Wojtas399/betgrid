import 'package:equatable/equatable.dart';

import 'driver.dart';
import 'season_driver.dart';
import 'team.dart' as team_model;

class DriverDetails extends Equatable {
  final Driver driver;
  final SeasonDriver seasonDriver;
  final team_model.Team team;

  const DriverDetails({
    required this.driver,
    required this.seasonDriver,
    required this.team,
  });

  @override
  List<Object?> get props => [
        driver,
        seasonDriver,
        team,
      ];
}
