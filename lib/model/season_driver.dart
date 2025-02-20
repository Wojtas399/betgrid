import 'entity.dart';

class SeasonDriver extends Entity {
  final int season;
  final String driverId;
  final int driverNumber;
  final String teamId;

  const SeasonDriver({
    required super.id,
    required this.season,
    required this.driverId,
    required this.driverNumber,
    required this.teamId,
  });

  @override
  List<Object?> get props => [id, season, driverId, driverNumber, teamId];
}
