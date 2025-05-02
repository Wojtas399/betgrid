import 'season_entity.dart';

class SeasonDriver extends SeasonEntity {
  final String driverId;
  final int driverNumber;
  final String teamId;

  const SeasonDriver({
    required super.id,
    required super.season,
    required this.driverId,
    required this.driverNumber,
    required this.teamId,
  });

  @override
  List<Object?> get props => [id, season, driverId, driverNumber, teamId];
}
