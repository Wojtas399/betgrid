import 'package:betgrid/data/firebase/model/grand_prix_bet_dto.dart';
import 'package:betgrid/model/grand_prix_bet.dart';

class GrandPrixBetCreator {
  final String id;
  final String playerId;
  final String grandPrixId;
  late final List<String?> qualiStandingsByDriverIds;
  final String? p1DriverId;
  final String? p2DriverId;
  final String? p3DriverId;
  final String? p10DriverId;
  final String? fastestLapDriverId;
  final List<String?> dnfDriverIds;
  final bool? willBeSafetyCar;
  final bool? willBeRedFlag;

  GrandPrixBetCreator({
    this.id = '',
    this.playerId = '',
    this.grandPrixId = '',
    List<String?>? qualiStandingsByDriverIds,
    this.p1DriverId,
    this.p2DriverId,
    this.p3DriverId,
    this.p10DriverId,
    this.fastestLapDriverId,
    this.dnfDriverIds = const [null, null, null],
    this.willBeSafetyCar,
    this.willBeRedFlag,
  }) {
    this.qualiStandingsByDriverIds =
        qualiStandingsByDriverIds ?? List.generate(20, (index) => null);
  }

  GrandPrixBet createEntity() => GrandPrixBet(
        id: id,
        playerId: playerId,
        grandPrixId: grandPrixId,
        qualiStandingsByDriverIds: qualiStandingsByDriverIds,
        p1DriverId: p1DriverId,
        p2DriverId: p2DriverId,
        p3DriverId: p3DriverId,
        p10DriverId: p10DriverId,
        fastestLapDriverId: fastestLapDriverId,
        dnfDriverIds: dnfDriverIds,
        willBeSafetyCar: willBeSafetyCar,
        willBeRedFlag: willBeRedFlag,
      );

  GrandPrixBetDto createDto() => GrandPrixBetDto(
        id: id,
        playerId: playerId,
        grandPrixId: grandPrixId,
        qualiStandingsByDriverIds: qualiStandingsByDriverIds,
        p1DriverId: p1DriverId,
        p2DriverId: p2DriverId,
        p3DriverId: p3DriverId,
        p10DriverId: p10DriverId,
        fastestLapDriverId: fastestLapDriverId,
        dnfDriverIds: dnfDriverIds,
        willBeSafetyCar: willBeSafetyCar,
        willBeRedFlag: willBeRedFlag,
      );
}
