import 'package:betgrid/data/firebase/model/grand_prix_bet_dto.dart';
import 'package:betgrid/model/grand_prix_bet.dart';

class GrandPrixBetCreator {
  final String id;
  final String playerId;
  final String grandPrixId;
  late final List<String?> qualiStandingsBySeasonDriverIds;
  final String? p1SeasonDriverId;
  final String? p2SeasonDriverId;
  final String? p3SeasonDriverId;
  final String? p10SeasonDriverId;
  final String? fastestLapSeasonDriverId;
  final List<String> dnfSeasonDriverIds;
  final bool? willBeSafetyCar;
  final bool? willBeRedFlag;

  GrandPrixBetCreator({
    this.id = '',
    this.playerId = '',
    this.grandPrixId = '',
    List<String?>? qualiStandingsByDriverIds,
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
        qualiStandingsByDriverIds ?? List.generate(20, (index) => null);
  }

  GrandPrixBet createEntity() => GrandPrixBet(
        id: id,
        playerId: playerId,
        grandPrixId: grandPrixId,
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

  GrandPrixBetDto createDto() => GrandPrixBetDto(
        id: id,
        playerId: playerId,
        grandPrixId: grandPrixId,
        qualiStandingsByDriverIds: qualiStandingsBySeasonDriverIds,
        p1DriverId: p1SeasonDriverId,
        p2DriverId: p2SeasonDriverId,
        p3DriverId: p3SeasonDriverId,
        p10DriverId: p10SeasonDriverId,
        fastestLapDriverId: fastestLapSeasonDriverId,
        dnfDriverIds: dnfSeasonDriverIds,
        willBeSafetyCar: willBeSafetyCar,
        willBeRedFlag: willBeRedFlag,
      );
}
