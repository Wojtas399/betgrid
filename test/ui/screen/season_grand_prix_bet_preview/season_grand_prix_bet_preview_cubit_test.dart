import 'package:betgrid/model/grand_prix_basic_info.dart';
import 'package:betgrid/model/season_grand_prix_bet_points.dart';
import 'package:betgrid/model/player.dart';
import 'package:betgrid/model/season_grand_prix.dart';
import 'package:betgrid/ui/screen/season_grand_prix_bet_preview/cubit/season_grand_prix_bet_preview_cubit.dart';
import 'package:betgrid/ui/screen/season_grand_prix_bet_preview/cubit/season_grand_prix_bet_preview_quali_bets_service.dart';
import 'package:betgrid/ui/screen/season_grand_prix_bet_preview/cubit/season_grand_prix_bet_preview_race_bets_service.dart';
import 'package:betgrid/ui/screen/season_grand_prix_bet_preview/cubit/season_grand_prix_bet_preview_state.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';

import '../../../creator/driver_details_creator.dart';
import '../../../creator/grand_prix_basic_info_creator.dart';
import '../../../creator/season_grand_prix_bet_points_creator.dart';
import '../../../creator/player_creator.dart';
import '../../../creator/season_grand_prix_creator.dart';
import '../../../mock/repository/mock_auth_repository.dart';
import '../../../mock/repository/mock_grand_prix_basic_info_repository.dart';
import '../../../mock/repository/mock_season_grand_prix_bet_points_repository.dart';
import '../../../mock/repository/mock_player_repository.dart';
import '../../../mock/repository/mock_season_grand_prix_repository.dart';
import '../../../mock/ui/screen/season_grand_prix_bet_preview/mock_season_grand_prix_bet_preview_quali_bets_service.dart';
import '../../../mock/ui/screen/season_grand_prix_bet_preview/mock_season_grand_prix_bet_preview_race_bets_service.dart';

void main() {
  final authRepository = MockAuthRepository();
  final seasonGrandPrixRepository = MockSeasonGrandPrixRepository();
  final grandPrixBasicInfoRepository = MockGrandPrixBasicInfoRepository();
  final playerRepository = MockPlayerRepository();
  final seasonGrandPrixBetPointsRepository =
      MockSeasonGrandPrixBetPointsRepository();
  final qualiBetsService = MockSeasonGrandPrixBetPreviewQualiBetsService();
  final raceBetsService = MockSeasonGrandPrixBetPreviewRaceBetsService();
  const String playerId = 'p1';
  const int season = 2024;
  const String seasonGrandPrixId = 'sgp1';

  SeasonGrandPrixBetPreviewCubit createCubit() =>
      SeasonGrandPrixBetPreviewCubit(
        authRepository,
        seasonGrandPrixRepository,
        grandPrixBasicInfoRepository,
        playerRepository,
        seasonGrandPrixBetPointsRepository,
        const GrandPrixBetCubitParams(
          playerId: playerId,
          season: season,
          seasonGrandPrixId: seasonGrandPrixId,
        ),
      );

  setUpAll(() {
    GetIt.I.registerFactory<SeasonGrandPrixBetPreviewQualiBetsService>(
      () => qualiBetsService,
    );
    GetIt.I.registerFactory<SeasonGrandPrixBetPreviewRaceBetsService>(
      () => raceBetsService,
    );
  });

  tearDown(() {
    reset(authRepository);
    reset(seasonGrandPrixRepository);
    reset(grandPrixBasicInfoRepository);
    reset(playerRepository);
    reset(seasonGrandPrixBetPointsRepository);
    reset(qualiBetsService);
    reset(raceBetsService);
  });

  group('initialize, '
      'should initialize canEdit, playerUsername, grandPrixId, grandPrixName, '
      'isPlayerIdSameAsLoggedUserId, quali and race bets and grand prix bet '
      'points', () {
    final Player player = const PlayerCreator(username: 'username').create();
    final SeasonGrandPrix seasonGrandPrix =
        SeasonGrandPrixCreator(
          id: seasonGrandPrixId,
          grandPrixId: 'gp1',
          startDate: DateTime(season, 3, 3),
        ).create();
    final GrandPrixBasicInfo grandPrixBasicInfo =
        GrandPrixBasicInfoCreator(
          id: seasonGrandPrix.grandPrixId,
          name: 'grand prix',
        ).create();
    final List<SingleDriverBet> qualiBets = List.generate(
      20,
      (int itemIndex) => SingleDriverBet(
        status: BetStatus.loss,
        betDriver: DriverDetailsCreator(seasonDriverId: 'd$itemIndex').create(),
        resultDriver:
            DriverDetailsCreator(seasonDriverId: 'd${itemIndex + 1}').create(),
        points: 0,
      ),
    );
    final List<SingleDriverBet> racePodiumBets = List.generate(
      3,
      (int itemIndex) => SingleDriverBet(
        status: BetStatus.win,
        betDriver: DriverDetailsCreator(seasonDriverId: 'd$itemIndex').create(),
        resultDriver:
            DriverDetailsCreator(seasonDriverId: 'd$itemIndex').create(),
        points: 2,
      ),
    );
    final SingleDriverBet raceP10Bet = SingleDriverBet(
      status: BetStatus.loss,
      betDriver: const DriverDetailsCreator(seasonDriverId: 'd10').create(),
      resultDriver: const DriverDetailsCreator(seasonDriverId: 'd11').create(),
      points: 0,
    );
    final SingleDriverBet raceFastestLapBet = SingleDriverBet(
      status: BetStatus.win,
      betDriver: const DriverDetailsCreator(seasonDriverId: 'd1').create(),
      resultDriver: const DriverDetailsCreator(seasonDriverId: 'd1').create(),
      points: 2,
    );
    final MultipleDriversBet raceDnfDriversBet = MultipleDriversBet(
      status: BetStatus.loss,
      betDrivers: [
        const DriverDetailsCreator(seasonDriverId: 'd19').create(),
        const DriverDetailsCreator(seasonDriverId: 'd20').create(),
      ],
      resultDrivers: [
        const DriverDetailsCreator(seasonDriverId: 'd18').create(),
      ],
      points: 0,
    );
    const BooleanBet raceSafetyCarBet = BooleanBet(
      status: BetStatus.win,
      betValue: true,
      resultValue: true,
      points: 2,
    );
    const BooleanBet raceRedFlagBet = BooleanBet(
      status: BetStatus.loss,
      betValue: false,
      resultValue: true,
      points: 0,
    );
    final SeasonGrandPrixBetPoints seasonGpBetPoints =
        const SeasonGrandPrixBetPointsCreator(id: 'gpb1').create();
    final SeasonGrandPrixBetPreviewState expectedState =
        SeasonGrandPrixBetPreviewState(
          status: SeasonGrandPrixBetPreviewStateStatus.completed,
          playerUsername: player.username,
          season: season,
          seasonGrandPrixId: seasonGrandPrixId,
          grandPrixName: grandPrixBasicInfo.name,
          qualiBets: qualiBets,
          racePodiumBets: racePodiumBets,
          raceP10Bet: raceP10Bet,
          raceFastestLapBet: raceFastestLapBet,
          raceDnfDriversBet: raceDnfDriversBet,
          raceSafetyCarBet: raceSafetyCarBet,
          raceRedFlagBet: raceRedFlagBet,
          seasonGrandPrixBetPoints: seasonGpBetPoints,
        );

    setUp(() {
      playerRepository.mockGetById(player: player);
      seasonGrandPrixRepository.mockGetById(
        expectedSeasonGrandPrix: seasonGrandPrix,
      );
      grandPrixBasicInfoRepository.mockGetGrandPrixBasicInfoById(
        expectedGrandPrixBasicInfo: grandPrixBasicInfo,
      );
      qualiBetsService.mockGetQualiBets(expectedQualiBets: qualiBets);
      raceBetsService.mockGetPodiumBets(expectedPodiumBets: racePodiumBets);
      raceBetsService.mockGetP10Bet(expectedP10Bet: raceP10Bet);
      raceBetsService.mockGetFastestLapBet(
        expectedFastestLapBet: raceFastestLapBet,
      );
      raceBetsService.mockGetDnfDriversBet(
        expectedDnfDriversBet: raceDnfDriversBet,
      );
      raceBetsService.mockGetSafetyCarBet(
        expectedSafetyCarBet: raceSafetyCarBet,
      );
      raceBetsService.mockGetRedFlagBet(expectedRedFlagBet: raceRedFlagBet);
      seasonGrandPrixBetPointsRepository.mockGetSeasonGetGrandPrixBetPoints(
        seasonGrandPrixBetPoints: seasonGpBetPoints,
      );
    });

    tearDown(() {
      verify(() => authRepository.loggedUserId$).called(1);
      verify(() => playerRepository.getById(playerId)).called(1);
      verify(
        () => seasonGrandPrixRepository.getById(
          season: season,
          seasonGrandPrixId: seasonGrandPrixId,
        ),
      ).called(1);
      verify(
        () => grandPrixBasicInfoRepository.getGrandPrixBasicInfoById(
          seasonGrandPrix.grandPrixId,
        ),
      ).called(1);
      verify(qualiBetsService.getQualiBets).called(1);
      verify(raceBetsService.getPodiumBets).called(1);
      verify(raceBetsService.getP10Bet).called(1);
      verify(raceBetsService.getFastestLapBet).called(1);
      verify(raceBetsService.getDnfDriversBet).called(1);
      verify(raceBetsService.getSafetyCarBet).called(1);
      verify(raceBetsService.getRedFlagBet).called(1);
      verify(
        () => seasonGrandPrixBetPointsRepository.getSeasonGrandPrixBetPoints(
          playerId: playerId,
          season: season,
          seasonGrandPrixId: seasonGrandPrixId,
        ),
      ).called(1);
    });

    blocTest(
      'should set isPlayerIdSameAsLoggedUserId param as true if player is '
      'logged user',
      build: () => createCubit(),
      setUp: () => authRepository.mockGetLoggedUserId(playerId),
      act: (cubit) => cubit.initialize(),
      expect:
          () => [expectedState.copyWith(isPlayerIdSameAsLoggedUserId: true)],
    );

    blocTest(
      'should set isPlayerIdSameAsLoggedUserId param as false if player is '
      'not logged user',
      build: () => createCubit(),
      setUp: () => authRepository.mockGetLoggedUserId('u1'),
      act: (cubit) => cubit.initialize(),
      expect:
          () => [expectedState.copyWith(isPlayerIdSameAsLoggedUserId: false)],
    );
  });
}
