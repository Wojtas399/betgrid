import 'package:betgrid/model/driver.dart';
import 'package:betgrid/ui/screen/stats/cubit/stats_cubit.dart';
import 'package:betgrid/ui/screen/stats/cubit/stats_state.dart';
import 'package:betgrid/ui/screen/stats/stats_model/players_podium.dart';
import 'package:betgrid/ui/screen/stats/stats_model/points_by_driver.dart';
import 'package:betgrid/ui/screen/stats/stats_model/points_history.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../creator/driver_creator.dart';
import '../../../creator/player_creator.dart';
import '../../../mock/data/repository/mock_driver_repository.dart';
import '../../../mock/ui/mock_players_podium_maker.dart';
import '../../../mock/ui/mock_points_for_driver_maker.dart';
import '../../../mock/ui/mock_points_history_maker.dart';

void main() {
  final driverRepository = MockDriverRepository();
  final playersPodiumMaker = MockPlayersPodiumMaker();
  final pointsHistoryMaker = MockPointsHistoryMaker();
  final pointsForDriverMaker = MockPointsForDriverMaker();

  StatsCubit createCubit() => StatsCubit(
        driverRepository,
        playersPodiumMaker,
        pointsHistoryMaker,
        pointsForDriverMaker,
      );

  tearDown(() {
    reset(driverRepository);
    reset(playersPodiumMaker);
    reset(pointsHistoryMaker);
    reset(pointsForDriverMaker);
  });

  blocTest(
    'initialize, '
    'should emit state with data of players podium chart and points history '
    'chart and list of all drivers',
    build: () => createCubit(),
    setUp: () {
      playersPodiumMaker.mock(
        playersPodium: PlayersPodium(
          p1Player: PlayersPodiumPlayer(
            player: createPlayer(id: 'p3'),
            points: 33,
          ),
        ),
      );
      pointsHistoryMaker.mock(
        pointsHistory: const PointsHistory(
          players: [],
          grandPrixes: [],
        ),
      );
      driverRepository.mockGetAllDrivers(allDrivers: [
        createDriver(id: 'd1', team: Team.ferrari),
        createDriver(id: 'd2', team: Team.redBullRacing),
        createDriver(id: 'd3', team: Team.alpine),
      ]);
    },
    act: (cubit) async => await cubit.initialize(),
    expect: () => [
      StatsState(
        status: StatsStateStatus.completed,
        playersPodium: PlayersPodium(
          p1Player: PlayersPodiumPlayer(
            player: createPlayer(id: 'p3'),
            points: 33,
          ),
        ),
        pointsHistory: const PointsHistory(
          players: [],
          grandPrixes: [],
        ),
        pointsByDriver: [],
        allDrivers: [
          createDriver(id: 'd3', team: Team.alpine),
          createDriver(id: 'd1', team: Team.ferrari),
          createDriver(id: 'd2', team: Team.redBullRacing),
        ],
      ),
    ],
    verify: (_) {
      verify(playersPodiumMaker.call).called(1);
      verify(pointsHistoryMaker.call).called(1);
      verify(() => driverRepository.getAllDrivers()).called(1);
    },
  );

  blocTest(
    'onDriverChanged, '
    'should emit state with points for driver chart data',
    build: () => createCubit(),
    setUp: () => pointsForDriverMaker.mock(
      playersPointsForDriver: [
        PointsByDriverPlayerPoints(
          player: createPlayer(id: 'p1'),
          points: 22.22,
        ),
      ],
    ),
    act: (cubit) async => await cubit.onDriverChanged('d1'),
    expect: () => [
      const StatsState(
        status: StatsStateStatus.pointsForDriverLoading,
      ),
      StatsState(
        status: StatsStateStatus.completed,
        pointsByDriver: [
          PointsByDriverPlayerPoints(
            player: createPlayer(id: 'p1'),
            points: 22.22,
          ),
        ],
      ),
    ],
    verify: (_) => verify(
      () => pointsForDriverMaker.call(driverId: 'd1'),
    ).called(1),
  );
}
