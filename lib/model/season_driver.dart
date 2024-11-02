import 'entity.dart';

class SeasonDriver extends Entity {
  final int seasonNumber;
  final String driverId;
  final int driverNumber;
  final String teamId;

  const SeasonDriver({
    required super.id,
    required this.seasonNumber,
    required this.driverId,
    required this.driverNumber,
    required this.teamId,
  });

  @override
  List<Object?> get props => [
        id,
        seasonNumber,
        driverId,
        driverNumber,
        teamId,
      ];
}
