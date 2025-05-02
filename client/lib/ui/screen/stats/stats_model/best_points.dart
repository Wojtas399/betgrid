import 'package:equatable/equatable.dart';

class BestPoints extends Equatable {
  final BestPointsForGp? bestGpPoints;
  final BestPointsForGp? bestQualiPoints;
  final BestPointsForGp? bestRacePoints;
  final BestPointsForDriver? bestDriverPoints;

  const BestPoints({
    this.bestGpPoints,
    this.bestQualiPoints,
    this.bestRacePoints,
    this.bestDriverPoints,
  });

  @override
  List<Object?> get props => [
    bestGpPoints,
    bestQualiPoints,
    bestRacePoints,
    bestDriverPoints,
  ];
}

abstract class BestPointsSingleStat extends Equatable {
  final double points;
  final String playerName;

  const BestPointsSingleStat({required this.points, required this.playerName});
}

class BestPointsForGp extends BestPointsSingleStat {
  final String? grandPrixName;

  const BestPointsForGp({
    required super.points,
    required super.playerName,
    required this.grandPrixName,
  });

  @override
  List<Object?> get props => [points, playerName, grandPrixName];
}

class BestPointsForDriver extends BestPointsSingleStat {
  final String? driverName;
  final String? driverSurname;

  const BestPointsForDriver({
    required super.points,
    required super.playerName,
    required this.driverName,
    required this.driverSurname,
  });

  @override
  List<Object?> get props => [points, playerName, driverName, driverSurname];
}
