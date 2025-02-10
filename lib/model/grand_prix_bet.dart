import 'entity.dart';

class GrandPrixBet extends Entity {
  final String playerId;
  final int season;
  final String seasonGrandPrixId;
  final List<String?> qualiStandingsBySeasonDriverIds;
  final String? p1SeasonDriverId;
  final String? p2SeasonDriverId;
  final String? p3SeasonDriverId;
  final String? p10SeasonDriverId;
  final String? fastestLapSeasonDriverId;
  final List<String> dnfSeasonDriverIds;
  final bool? willBeSafetyCar;
  final bool? willBeRedFlag;

  const GrandPrixBet({
    required super.id,
    required this.playerId,
    required this.season,
    required this.seasonGrandPrixId,
    required this.qualiStandingsBySeasonDriverIds,
    this.p1SeasonDriverId,
    this.p2SeasonDriverId,
    this.p3SeasonDriverId,
    this.p10SeasonDriverId,
    this.fastestLapSeasonDriverId,
    required this.dnfSeasonDriverIds,
    this.willBeSafetyCar,
    this.willBeRedFlag,
  }) : assert(qualiStandingsBySeasonDriverIds.length == 20);

  @override
  List<Object?> get props => [
        id,
        playerId,
        season,
        seasonGrandPrixId,
        qualiStandingsBySeasonDriverIds,
        p1SeasonDriverId,
        p2SeasonDriverId,
        p3SeasonDriverId,
        p10SeasonDriverId,
        fastestLapSeasonDriverId,
        dnfSeasonDriverIds,
        willBeSafetyCar,
        willBeRedFlag,
      ];
}
