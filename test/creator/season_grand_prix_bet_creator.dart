import 'package:betgrid/model/season_grand_prix_bet.dart';

class SeasonGrandPrixBetCreator {
  final String id;
  final int season;
  final String playerId;
  final String seasonGrandPrixId;
  late final List<String?> qualiStandingsBySeasonDriverIds;
  final String? p1SeasonDriverId;
  final String? p2SeasonDriverId;
  final String? p3SeasonDriverId;
  final String? p10SeasonDriverId;
  final String? fastestLapSeasonDriverId;
  final List<String> dnfSeasonDriverIds;
  final bool? willBeSafetyCar;
  final bool? willBeRedFlag;

  SeasonGrandPrixBetCreator({
    this.id = '',
    this.playerId = '',
    this.season = 0,
    this.seasonGrandPrixId = '',
    List<String?>? qualiStandingsBySeasonDriverIds,
    this.p1SeasonDriverId,
    this.p2SeasonDriverId,
    this.p3SeasonDriverId,
    this.p10SeasonDriverId,
    this.fastestLapSeasonDriverId,
    this.dnfSeasonDriverIds = const [],
    this.willBeSafetyCar,
    this.willBeRedFlag,
  }) {
    this.qualiStandingsBySeasonDriverIds =
        qualiStandingsBySeasonDriverIds ?? List.generate(20, (index) => null);
  }

  SeasonGrandPrixBet create() => SeasonGrandPrixBet(
        id: id,
        playerId: playerId,
        season: season,
        seasonGrandPrixId: seasonGrandPrixId,
        qualiStandingsBySeasonDriverIds: qualiStandingsBySeasonDriverIds,
        p1SeasonDriverId: p1SeasonDriverId,
        p2SeasonDriverId: p2SeasonDriverId,
        p3SeasonDriverId: p3SeasonDriverId,
        p10SeasonDriverId: p10SeasonDriverId,
        fastestLapSeasonDriverId: fastestLapSeasonDriverId,
        dnfSeasonDriverIds: dnfSeasonDriverIds,
        willBeSafetyCar: willBeSafetyCar,
        willBeRedFlag: willBeRedFlag,
      );
}
