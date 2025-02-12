import 'dart:async';

import 'package:betgrid/model/driver_details.dart';
import 'package:betgrid/model/season_grand_prix_bet.dart';
import 'package:betgrid/ui/screen/grand_prix_bet_editor/cubit/grand_prix_bet_editor_cubit.dart';
import 'package:betgrid/ui/screen/grand_prix_bet_editor/cubit/grand_prix_bet_editor_race_form.dart';
import 'package:betgrid/ui/screen/grand_prix_bet_editor/cubit/grand_prix_bet_editor_state.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../creator/driver_details_creator.dart';
import '../../../creator/season_grand_prix_bet_creator.dart';
import '../../../mock/repository/mock_auth_repository.dart';
import '../../../mock/repository/mock_season_grand_prix_bet_repository.dart';
import '../../../mock/use_case/mock_get_details_for_all_drivers_from_season_use_case.dart';

void main() {
  final authRepository = MockAuthRepository();
  final seasonGrandPrixBetRepository = MockSeasonGrandPrixBetRepository();
  final getDetailsOfAllDriversFromSeasonUseCase =
      MockGetDetailsOfAllDriversFromSeasonUseCase();
  const int season = 2024;
  const String seasonGrandPrixId = 'gp1';

  GrandPrixBetEditorCubit createCubit() => GrandPrixBetEditorCubit(
        authRepository,
        seasonGrandPrixBetRepository,
        getDetailsOfAllDriversFromSeasonUseCase,
        season,
        seasonGrandPrixId,
      );

  tearDown(() {
    reset(authRepository);
    reset(seasonGrandPrixBetRepository);
    reset(getDetailsOfAllDriversFromSeasonUseCase);
  });

  group(
    'initialize',
    () {
      const String loggedUserId = 'u1';
      final List<DriverDetails> allDrivers = [
        const DriverDetailsCreator(
          seasonDriverId: 'd1',
          teamName: 'Mercedes',
          surname: 'Russel',
        ).create(),
        const DriverDetailsCreator(
          seasonDriverId: 'd2',
          teamName: 'Alpine',
        ).create(),
        const DriverDetailsCreator(
          seasonDriverId: 'd3',
          teamName: 'Mercedes',
          surname: 'Hamilton',
        ).create(),
      ];
      final bet = SeasonGrandPrixBetCreator(
        qualiStandingsBySeasonDriverIds: List.generate(
          20,
          (int driverIndex) => 'd${driverIndex + 1}',
        ),
        p1SeasonDriverId: 'd1',
        p2SeasonDriverId: 'd2',
        p3SeasonDriverId: 'd3',
        p10SeasonDriverId: 'd10',
        fastestLapSeasonDriverId: 'd1',
        dnfSeasonDriverIds: ['d1'],
        willBeSafetyCar: true,
        willBeRedFlag: false,
      ).create();
      final updatedBet = SeasonGrandPrixBetCreator(
        qualiStandingsBySeasonDriverIds: List.generate(
          20,
          (int driverIndex) => 'd${driverIndex + 1}',
        ),
        p1SeasonDriverId: 'd1',
        p2SeasonDriverId: 'd2',
        p3SeasonDriverId: 'd3',
        p10SeasonDriverId: 'd10',
        fastestLapSeasonDriverId: 'd1',
        dnfSeasonDriverIds: ['d1', 'd2'],
        willBeSafetyCar: true,
        willBeRedFlag: false,
      ).create();
      final bet$ = StreamController<SeasonGrandPrixBet>()..add(bet);
      GrandPrixBetEditorState? state;

      blocTest(
        'should load details of all drivers, should listen to grand prix bet '
        'and should emit existing bets and all drivers sorted by team and '
        'surname',
        build: () => createCubit(),
        setUp: () {
          getDetailsOfAllDriversFromSeasonUseCase.mock(
            expectedDetailsOfAllDriversFromSeason: allDrivers,
          );
          authRepository.mockGetLoggedUserId(loggedUserId);
          when(
            () => seasonGrandPrixBetRepository.getSeasonGrandPrixBet(
              playerId: loggedUserId,
              season: season,
              seasonGrandPrixId: seasonGrandPrixId,
            ),
          ).thenAnswer((_) => bet$.stream);
        },
        act: (cubit) {
          cubit.initialize();
          bet$.add(updatedBet);
        },
        expect: () => [
          state = GrandPrixBetEditorState(
            status: GrandPrixBetEditorStateStatus.completed,
            allDrivers: [
              allDrivers[1],
              allDrivers.last,
              allDrivers.first,
            ],
            originalSeasonGrandPrixBet: bet,
            qualiStandingsBySeasonDriverIds:
                bet.qualiStandingsBySeasonDriverIds,
            raceForm: GrandPrixBetEditorRaceForm(
              p1SeasonDriverId: bet.p1SeasonDriverId,
              p2SeasonDriverId: bet.p2SeasonDriverId,
              p3SeasonDriverId: bet.p3SeasonDriverId,
              p10SeasonDriverId: bet.p10SeasonDriverId,
              fastestLapSeasonDriverId: bet.fastestLapSeasonDriverId,
              dnfDrivers: [
                allDrivers.first,
              ],
              willBeSafetyCar: bet.willBeSafetyCar,
              willBeRedFlag: bet.willBeRedFlag,
            ),
          ),
          state = state!.copyWith(
            originalSeasonGrandPrixBet: updatedBet,
            raceForm: state!.raceForm.copyWith(
              dnfDrivers: [
                allDrivers.first,
                allDrivers[1],
              ],
            ),
          ),
        ],
        verify: (_) {
          verify(
            () => getDetailsOfAllDriversFromSeasonUseCase.call(2024),
          ).called(1);
          verify(() => authRepository.loggedUserId$).called(1);
          verify(
            () => seasonGrandPrixBetRepository.getSeasonGrandPrixBet(
              playerId: loggedUserId,
              season: season,
              seasonGrandPrixId: seasonGrandPrixId,
            ),
          ).called(1);
        },
      );
    },
  );

  group(
    'onQualiStandingsChanged',
    () {
      const String driverId = 'd1';

      blocTest(
        'should set driverId at standing - 1 position in '
        'qualiStandingsBySeasonDriverIds',
        build: () => createCubit(),
        act: (cubit) => cubit.onQualiStandingsChanged(
          standing: 10,
          driverId: driverId,
        ),
        expect: () => [
          GrandPrixBetEditorState(
            status: GrandPrixBetEditorStateStatus.completed,
            qualiStandingsBySeasonDriverIds: List.generate(
              20,
              (int standingIndex) => standingIndex == 9 ? driverId : null,
            ),
          ),
        ],
      );

      blocTest(
        'should set null at index where the value is the same as driverId and '
        'then should set driverId at standing - 1 position',
        build: () => createCubit(),
        seed: () => GrandPrixBetEditorState(
          qualiStandingsBySeasonDriverIds: List.generate(
            20,
            (int standingIndex) => standingIndex == 3 ? driverId : null,
          ),
        ),
        act: (cubit) =>
            cubit.onQualiStandingsChanged(standing: 8, driverId: driverId),
        expect: () => [
          GrandPrixBetEditorState(
            status: GrandPrixBetEditorStateStatus.completed,
            qualiStandingsBySeasonDriverIds: List.generate(
              20,
              (int standingIndex) => standingIndex == 7 ? driverId : null,
            ),
          ),
        ],
      );
    },
  );

  //TODO: Test cases when user select the same seasonDriverId for p1, p2, p3 and p10
  blocTest(
    'onRaceP1DriverChanged, '
    'should assign passed driverId to p1SeasonDriverId in raceForm',
    build: () => createCubit(),
    act: (cubit) => cubit.onRaceP1DriverChanged('d1'),
    expect: () => [
      const GrandPrixBetEditorState(
        status: GrandPrixBetEditorStateStatus.completed,
        raceForm: GrandPrixBetEditorRaceForm(
          p1SeasonDriverId: 'd1',
        ),
      ),
    ],
  );

  blocTest(
    'onRaceP2DriverChanged, '
    'should assign passed driverId to p2SeasonDriverId in raceForm',
    build: () => createCubit(),
    act: (cubit) => cubit.onRaceP2DriverChanged('d1'),
    expect: () => [
      const GrandPrixBetEditorState(
        status: GrandPrixBetEditorStateStatus.completed,
        raceForm: GrandPrixBetEditorRaceForm(
          p2SeasonDriverId: 'd1',
        ),
      ),
    ],
  );

  blocTest(
    'onRaceP3DriverChanged, '
    'should assign passed driverId to p3SeasonDriverId in raceForm',
    build: () => createCubit(),
    act: (cubit) => cubit.onRaceP3DriverChanged('d1'),
    expect: () => [
      const GrandPrixBetEditorState(
        status: GrandPrixBetEditorStateStatus.completed,
        raceForm: GrandPrixBetEditorRaceForm(
          p3SeasonDriverId: 'd1',
        ),
      ),
    ],
  );

  blocTest(
    'onRaceP10DriverChanged, '
    'should assign passed driverId to p10SeasonDriverId in raceForm',
    build: () => createCubit(),
    act: (cubit) => cubit.onRaceP10DriverChanged('d1'),
    expect: () => [
      const GrandPrixBetEditorState(
        status: GrandPrixBetEditorStateStatus.completed,
        raceForm: GrandPrixBetEditorRaceForm(
          p10SeasonDriverId: 'd1',
        ),
      ),
    ],
  );

  blocTest(
    'onRaceFastestLapDriverChanged, '
    'should assign passed driverId to fastestLapSeasonDriverId in raceForm',
    build: () => createCubit(),
    act: (cubit) => cubit.onRaceFastestLapDriverChanged('d1'),
    expect: () => [
      const GrandPrixBetEditorState(
        status: GrandPrixBetEditorStateStatus.completed,
        raceForm: GrandPrixBetEditorRaceForm(
          fastestLapSeasonDriverId: 'd1',
        ),
      ),
    ],
  );

  group(
    'onDnfDriverSelected',
    () {
      const String driverId = 'd1';
      final List<DriverDetails> allDrivers = [
        const DriverDetailsCreator(seasonDriverId: driverId).create(),
        const DriverDetailsCreator(seasonDriverId: 'd2').create(),
      ];
      GrandPrixBetEditorState? state;

      blocTest(
        'should do nothing if allDrivers list is empty',
        build: () => createCubit(),
        seed: () => const GrandPrixBetEditorState(
          allDrivers: [],
        ),
        act: (cubit) => cubit.onDnfDriverSelected(driverId),
        expect: () => [],
      );

      blocTest(
        'should do nothing if driver_personal_data with matching id does not exist in '
        'allDrivers list',
        build: () => createCubit(),
        seed: () => GrandPrixBetEditorState(
          status: GrandPrixBetEditorStateStatus.completed,
          allDrivers: allDrivers,
        ),
        act: (cubit) => cubit.onDnfDriverSelected('d3'),
        expect: () => [],
      );

      blocTest(
        'should do nothing if driver_personal_data with matching id already exists in '
        'dnfDrivers list of raceForm',
        build: () => createCubit(),
        seed: () => GrandPrixBetEditorState(
          allDrivers: allDrivers,
          originalSeasonGrandPrixBet: SeasonGrandPrixBetCreator(
            dnfSeasonDriverIds: [driverId, 'd2'],
          ).create(),
          raceForm: GrandPrixBetEditorRaceForm(
            dnfDrivers: allDrivers,
          ),
        ),
        act: (cubit) => cubit.onDnfDriverSelected(driverId),
        expect: () => [],
      );

      blocTest(
        'should add driver_personal_data to dnfDrivers list of raceForm if driver_personal_data with '
        'matching id does not exist in this list',
        build: () => createCubit(),
        seed: () => state = GrandPrixBetEditorState(
          allDrivers: allDrivers,
          originalSeasonGrandPrixBet: SeasonGrandPrixBetCreator(
            dnfSeasonDriverIds: ['d2'],
          ).create(),
          raceForm: GrandPrixBetEditorRaceForm(
            dnfDrivers: [allDrivers.last],
          ),
        ),
        act: (cubit) => cubit.onDnfDriverSelected(driverId),
        expect: () => [
          state = state!.copyWith(
            raceForm: state!.raceForm.copyWith(
              dnfDrivers: [allDrivers.last, allDrivers.first],
            ),
          ),
        ],
      );
    },
  );

  group(
    'onDnfDriverRemoved',
    () {
      const String driverId = 'd1';
      final List<DriverDetails> allDrivers = [
        const DriverDetailsCreator(seasonDriverId: driverId).create(),
        const DriverDetailsCreator(seasonDriverId: 'd2').create(),
      ];
      GrandPrixBetEditorState? state;

      blocTest(
        'should do nothing if allDrivers list is empty',
        build: () => createCubit(),
        seed: () => const GrandPrixBetEditorState(
          allDrivers: [],
        ),
        act: (cubit) => cubit.onDnfDriverRemoved(driverId),
        expect: () => [],
      );

      blocTest(
        'should do nothing if driver_personal_data with matching id does not exist in '
        'dnfDrivers list of raceForm',
        build: () => createCubit(),
        seed: () => state = GrandPrixBetEditorState(
          allDrivers: allDrivers,
          originalSeasonGrandPrixBet: SeasonGrandPrixBetCreator(
            dnfSeasonDriverIds: ['d2'],
          ).create(),
          raceForm: GrandPrixBetEditorRaceForm(
            dnfDrivers: [allDrivers.last],
          ),
        ),
        act: (cubit) => cubit.onDnfDriverRemoved(driverId),
        expect: () => [],
      );

      blocTest(
        'should remove driver_personal_data from dnfDrivers list of raceForm if driver_personal_data with '
        'matching id exists in this list',
        build: () => createCubit(),
        seed: () => state = GrandPrixBetEditorState(
          allDrivers: allDrivers,
          originalSeasonGrandPrixBet: SeasonGrandPrixBetCreator(
            dnfSeasonDriverIds: ['d2', driverId],
          ).create(),
          raceForm: GrandPrixBetEditorRaceForm(
            dnfDrivers: [allDrivers.last, allDrivers.first],
          ),
        ),
        act: (cubit) => cubit.onDnfDriverRemoved(driverId),
        expect: () => [
          state = state!.copyWith(
            raceForm: state!.raceForm.copyWith(
              dnfDrivers: [allDrivers.last],
            ),
          ),
        ],
      );
    },
  );

  blocTest(
    'onSafetyCarPredictionChanged, '
    'should assign passed willBeSafetyCar to willBeSafetyCar of raceForm',
    build: () => createCubit(),
    act: (cubit) => cubit.onSafetyCarPredictionChanged(false),
    expect: () => [
      const GrandPrixBetEditorState(
        status: GrandPrixBetEditorStateStatus.completed,
        raceForm: GrandPrixBetEditorRaceForm(
          willBeSafetyCar: false,
        ),
      ),
    ],
  );

  blocTest(
    'onRedFlagPredictionChanged, '
    'should assign passed willBeRedFlag to willBeRedFlag of raceForm',
    build: () => createCubit(),
    act: (cubit) => cubit.onRedFlagPredictionChanged(false),
    expect: () => [
      const GrandPrixBetEditorState(
        status: GrandPrixBetEditorStateStatus.completed,
        raceForm: GrandPrixBetEditorRaceForm(
          willBeRedFlag: false,
        ),
      ),
    ],
  );

  group(
    'submit',
    () {
      const String loggedUserId = 'u1';
      const String grandPrixBetId = 'gpb1';
      final List<String?> qualiStandingsBySeasonDriverIds = List.generate(
        20,
        (int index) => switch (index) {
          0 => 'd1',
          9 => 'd10',
          _ => null,
        },
      );
      const String p1SeasonDriverId = 'd1';
      const String p2SeasonDriverId = 'd2';
      const String p3SeasonDriverId = 'd3';
      const String p10SeasonDriverId = 'd10';
      const String fastestLapSeasonDriverId = 'd1';
      const List<String> dnfSeasonDriverIds = ['d1', 'd2'];
      const bool willBeSafetyCar = false;
      const bool willBeRedFlag = true;
      final List<DriverDetails> allDrivers = [
        const DriverDetailsCreator(seasonDriverId: 'd1').create(),
        const DriverDetailsCreator(seasonDriverId: 'd2').create(),
        const DriverDetailsCreator(seasonDriverId: 'd3').create(),
        const DriverDetailsCreator(seasonDriverId: 'd10').create(),
      ];
      GrandPrixBetEditorState? state;

      blocTest(
        'should finish method call if logged user does not exist',
        build: () => createCubit(),
        setUp: () => authRepository.mockGetLoggedUserId(null),
        act: (cubit) async => await cubit.submit(),
        expect: () => [],
      );

      blocTest(
        'should call addGrandPrixBet method from GrandPrixBetRepository if bet '
        'does not exist in GrandPrixBetRepository',
        build: () => createCubit(),
        setUp: () {
          authRepository.mockGetLoggedUserId(loggedUserId);
          seasonGrandPrixBetRepository.mockGetSeasonGrandPrixBet();
          seasonGrandPrixBetRepository.mockAddSeasonGrandPrixBet();
        },
        seed: () => state = GrandPrixBetEditorState(
          qualiStandingsBySeasonDriverIds: qualiStandingsBySeasonDriverIds,
          raceForm: GrandPrixBetEditorRaceForm(
            p1SeasonDriverId: p1SeasonDriverId,
            p2SeasonDriverId: p2SeasonDriverId,
            p3SeasonDriverId: p3SeasonDriverId,
            p10SeasonDriverId: p10SeasonDriverId,
            fastestLapSeasonDriverId: fastestLapSeasonDriverId,
            dnfDrivers: [allDrivers.first, allDrivers[1]],
            willBeSafetyCar: willBeSafetyCar,
            willBeRedFlag: willBeRedFlag,
          ),
        ),
        act: (cubit) async => await cubit.submit(),
        expect: () => [
          state = state!.copyWith(
            status: GrandPrixBetEditorStateStatus.saving,
          ),
          state = state!.copyWith(
            status: GrandPrixBetEditorStateStatus.successfullySaved,
          ),
        ],
        verify: (_) => verify(
          () => seasonGrandPrixBetRepository.addSeasonGrandPrixBet(
            playerId: loggedUserId,
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
          ),
        ).called(1),
      );

      blocTest(
        'should call updateGrandPrixBet method from GrandPrixBetRepository if '
        'bet exists in GrandPrixBetRepository',
        build: () => createCubit(),
        setUp: () {
          authRepository.mockGetLoggedUserId(loggedUserId);
          seasonGrandPrixBetRepository.mockGetSeasonGrandPrixBet();
          seasonGrandPrixBetRepository.mockUpdateSeasonGrandPrixBet();
        },
        seed: () => state = GrandPrixBetEditorState(
          qualiStandingsBySeasonDriverIds: qualiStandingsBySeasonDriverIds,
          originalSeasonGrandPrixBet: SeasonGrandPrixBetCreator(
            id: grandPrixBetId,
          ).create(),
          raceForm: GrandPrixBetEditorRaceForm(
            p1SeasonDriverId: p1SeasonDriverId,
            p2SeasonDriverId: p2SeasonDriverId,
            p3SeasonDriverId: p3SeasonDriverId,
            p10SeasonDriverId: p10SeasonDriverId,
            fastestLapSeasonDriverId: fastestLapSeasonDriverId,
            dnfDrivers: [allDrivers.first, allDrivers[1]],
            willBeSafetyCar: willBeSafetyCar,
            willBeRedFlag: willBeRedFlag,
          ),
        ),
        act: (cubit) async => await cubit.submit(),
        expect: () => [
          state = state!.copyWith(
            status: GrandPrixBetEditorStateStatus.saving,
          ),
          state = state!.copyWith(
            status: GrandPrixBetEditorStateStatus.successfullySaved,
          ),
        ],
        verify: (_) => verify(
          () => seasonGrandPrixBetRepository.updateSeasonGrandPrixBet(
            playerId: loggedUserId,
            season: season,
            seasonGrandPrixId: grandPrixBetId,
            qualiStandingsBySeasonDriverIds: qualiStandingsBySeasonDriverIds,
            p1SeasonDriverId: p1SeasonDriverId,
            p2SeasonDriverId: p2SeasonDriverId,
            p3SeasonDriverId: p3SeasonDriverId,
            p10SeasonDriverId: p10SeasonDriverId,
            fastestLapSeasonDriverId: fastestLapSeasonDriverId,
            dnfSeasonDriverIds: dnfSeasonDriverIds,
            willBeSafetyCar: willBeSafetyCar,
            willBeRedFlag: willBeRedFlag,
          ),
        ).called(1),
      );
    },
  );
}
