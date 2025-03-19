import 'entity.dart';

class SeasonDriver extends Entity {
  final int season;
  final String driverId;
  final int driverNumber;
  final String seasonTeamId;

  const SeasonDriver({
    required super.id,
    required this.season,
    required this.driverId,
    required this.driverNumber,
    required this.seasonTeamId,
  });

  @override
  List<Object?> get props => [id, season, driverId, driverNumber, seasonTeamId];
}
