import 'package:betgrid/model/season_grand_prix_bet_points.dart';
import 'package:betgrid/model/player.dart';
import 'package:betgrid/model/season_grand_prix.dart';
import 'package:betgrid/ui/screen/stats/cubit/stats_state.dart';
import 'package:betgrid/ui/screen/stats/stats_creator/create_points_history_stats.dart';
import 'package:betgrid/ui/screen/stats/stats_model/points_history.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../creator/season_grand_prix_bet_points_creator.dart';
import '../../../creator/player_creator.dart';
import '../../../creator/season_grand_prix_creator.dart';
import '../../../mock/repository/mock_auth_repository.dart';
import '../../../mock/repository/mock_season_grand_prix_bet_points_repository.dart';
import '../../../mock/repository/mock_player_repository.dart';
import '../../../mock/use_case/mock_get_finished_grand_prixes_from_season_use_case.dart';

void main() {
  final authRepository = MockAuthRepository();
  final playerRepository = MockPlayerRepository();
  final getFinishedGrandPrixesFromSeasonUseCase =
      MockGetFinishedGrandPrixesFromSeasonUseCase();
  final seasonGrandPrixBetPointsRepository =
      MockSeasonGrandPrixBetPointsRepository();
  const season = 2025;

  late CreatePointsHistoryStats createPointsHistoryStats;

  setUp(() {
    createPointsHistoryStats = CreatePointsHistoryStats(
      authRepository,
      playerRepository,
      getFinishedGrandPrixesFromSeasonUseCase,
      seasonGrandPrixBetPointsRepository,
    );
  });

  tearDown(() {
    reset(authRepository);
    reset(playerRepository);
    reset(getFinishedGrandPrixesFromSeasonUseCase);
    reset(seasonGrandPrixBetPointsRepository);
  });

  group(
    'grouped, ',
    () {
      const StatsType statsType = StatsType.grouped;

      tearDown(() {
        verify(playerRepository.getAll).called(1);
        verify(
          () => getFinishedGrandPrixesFromSeasonUseCase.call(
            season: season,
          ),
        ).called(1);
      });

      test(
        'should emit null if list of players is empty',
        () async {
          playerRepository.mockGetAll(players: []);
          getFinishedGrandPrixesFromSeasonUseCase.mock(
            finishedSeasonGrandPrixes: [
              SeasonGrandPrixCreator(id: 'sgp1').create(),
              SeasonGrandPrixCreator(id: 'sgp2').create(),
            ],
          );

          final Stream<PointsHistory?> pointsHistory$ =
              createPointsHistoryStats(
            statsType: statsType,
            season: season,
          );

          expect(await pointsHistory$.first, null);
        },
      );

      test(
        'should return null if list of finished grand prixes is empty',
        () async {
          playerRepository.mockGetAll(
            players: [
              const PlayerCreator(id: 'p1').create(),
              const PlayerCreator(id: 'p2').create(),
            ],
          );
          getFinishedGrandPrixesFromSeasonUseCase.mock(
            finishedSeasonGrandPrixes: [],
          );

          final Stream<PointsHistory?> pointsHistory$ =
              createPointsHistoryStats(
            statsType: statsType,
            season: season,
          );

          expect(await pointsHistory$.first, null);
        },
      );

      test(
        'for each player should create cumulative sum of points gained for each '
        'grand prix',
        () async {
          final List<Player> players = [
            const PlayerCreator(id: 'p1').create(),
            const PlayerCreator(id: 'p2').create(),
            const PlayerCreator(id: 'p3').create(),
          ];
          final List<SeasonGrandPrix> finishedSeasonGrandPrixes = [
            SeasonGrandPrixCreator(id: 'sgp1', roundNumber: 2).create(),
            SeasonGrandPrixCreator(id: 'sgp2', roundNumber: 3).create(),
            SeasonGrandPrixCreator(id: 'sgp3', roundNumber: 1).create(),
          ];
          final List<SeasonGrandPrixBetPoints> grandPrixesBetPoints = [
            SeasonGrandPrixBetPointsCreator(
              playerId: players.first.id,
              seasonGrandPrixId: finishedSeasonGrandPrixes.first.id,
              totalPoints: 20,
            ).create(),
            SeasonGrandPrixBetPointsCreator(
              playerId: players.first.id,
              seasonGrandPrixId: finishedSeasonGrandPrixes[1].id,
              totalPoints: 12.2,
            ).create(),
            SeasonGrandPrixBetPointsCreator(
              playerId: players.first.id,
              seasonGrandPrixId: finishedSeasonGrandPrixes.last.id,
              totalPoints: 17,
            ).create(),
            SeasonGrandPrixBetPointsCreator(
              playerId: players[1].id,
              seasonGrandPrixId: finishedSeasonGrandPrixes.first.id,
              totalPoints: 5.5,
            ).create(),
            SeasonGrandPrixBetPointsCreator(
              playerId: players[1].id,
              seasonGrandPrixId: finishedSeasonGrandPrixes[1].id,
              totalPoints: 17,
            ).create(),
            SeasonGrandPrixBetPointsCreator(
              playerId: players[1].id,
              seasonGrandPrixId: finishedSeasonGrandPrixes.last.id,
              totalPoints: 9,
            ).create(),
            SeasonGrandPrixBetPointsCreator(
              playerId: players.last.id,
              seasonGrandPrixId: finishedSeasonGrandPrixes.first.id,
              totalPoints: 15,
            ).create(),
            SeasonGrandPrixBetPointsCreator(
              playerId: players.last.id,
              seasonGrandPrixId: finishedSeasonGrandPrixes[1].id,
              totalPoints: 17,
            ).create(),
          ];
          final PointsHistory expectedPointsHistory = PointsHistory(
            players: players,
            grandPrixes: [
              PointsHistoryGrandPrix(
                roundNumber: 1,
                playersPoints: [
                  PointsHistoryPlayerPoints(
                    playerId: players.first.id,
                    points: 17,
                  ),
                  PointsHistoryPlayerPoints(
                    playerId: players[1].id,
                    points: 9,
                  ),
                  PointsHistoryPlayerPoints(
                    playerId: players.last.id,
                    points: 0,
                  ),
                ],
              ),
              PointsHistoryGrandPrix(
                roundNumber: 2,
                playersPoints: [
                  PointsHistoryPlayerPoints(
                    playerId: players.first.id,
                    points: 37,
                  ),
                  PointsHistoryPlayerPoints(
                    playerId: players[1].id,
                    points: 14.5,
                  ),
                  PointsHistoryPlayerPoints(
                    playerId: players.last.id,
                    points: 15,
                  ),
                ],
              ),
              PointsHistoryGrandPrix(
                roundNumber: 3,
                playersPoints: [
                  PointsHistoryPlayerPoints(
                    playerId: players.first.id,
                    points: 49.2,
                  ),
                  PointsHistoryPlayerPoints(
                    playerId: players[1].id,
                    points: 31.5,
                  ),
                  PointsHistoryPlayerPoints(
                    playerId: players.last.id,
                    points: 32,
                  ),
                ],
              ),
            ],
          );
          playerRepository.mockGetAll(players: players);
          getFinishedGrandPrixesFromSeasonUseCase.mock(
            finishedSeasonGrandPrixes: finishedSeasonGrandPrixes,
          );
          seasonGrandPrixBetPointsRepository
              .mockGetSeasonGrandPrixBetPointsForPlayersAndSeasonGrandPrixes(
            seasonGrandPrixesBetPoints: grandPrixesBetPoints,
          );

          final Stream<PointsHistory?> pointsHistory$ =
              createPointsHistoryStats(
            statsType: statsType,
            season: season,
          );

          expect(await pointsHistory$.first, expectedPointsHistory);
          verify(
            () => seasonGrandPrixBetPointsRepository
                .getSeasonGrandPrixBetPointsForPlayersAndSeasonGrandPrixes(
              season: season,
              idsOfPlayers: players.map((player) => player.id).toList(),
              idsOfSeasonGrandPrixes:
                  finishedSeasonGrandPrixes.map((gp) => gp.id).toList(),
            ),
          ).called(1);
        },
      );
    },
  );

  group(
    'individual, ',
    () {
      const StatsType statsType = StatsType.individual;

      tearDown(() {
        verify(() => authRepository.loggedUserId$).called(1);
        verify(
          () => getFinishedGrandPrixesFromSeasonUseCase.call(season: 2025),
        ).called(1);
      });

      test(
        'should emit null if logged user id is null',
        () async {
          authRepository.mockGetLoggedUserId(null);
          getFinishedGrandPrixesFromSeasonUseCase.mock(
            finishedSeasonGrandPrixes: [
              SeasonGrandPrixCreator(id: 'sgp1').create(),
              SeasonGrandPrixCreator(id: 'sgp2').create(),
            ],
          );

          final Stream<PointsHistory?> pointsHistory$ =
              createPointsHistoryStats(
            statsType: statsType,
            season: season,
          );

          expect(await pointsHistory$.first, null);
        },
      );

      test(
        'should emit null if logged user data does not exist',
        () async {
          const String loggedUserId = 'p1';
          authRepository.mockGetLoggedUserId(loggedUserId);
          playerRepository.mockGetById(player: null);
          getFinishedGrandPrixesFromSeasonUseCase.mock(
            finishedSeasonGrandPrixes: [
              SeasonGrandPrixCreator(id: 'sgp1').create(),
              SeasonGrandPrixCreator(id: 'sgp2').create(),
            ],
          );

          final Stream<PointsHistory?> pointsHistory$ =
              createPointsHistoryStats(
            statsType: statsType,
            season: season,
          );

          expect(await pointsHistory$.first, null);
        },
      );

      test(
        'should return null if list of finished grand prixes is empty',
        () async {
          const String loggedUserId = 'p1';
          final Player loggedUser = const PlayerCreator(
            id: loggedUserId,
            username: 'logged user',
          ).create();
          authRepository.mockGetLoggedUserId(loggedUserId);
          playerRepository.mockGetById(player: loggedUser);
          getFinishedGrandPrixesFromSeasonUseCase.mock(
            finishedSeasonGrandPrixes: [],
          );

          final Stream<PointsHistory?> pointsHistory$ =
              createPointsHistoryStats(
            statsType: statsType,
            season: season,
          );

          expect(await pointsHistory$.first, null);
        },
      );

      test(
        ' should create cumulative sum of points gained for each grand prix by '
        'logged user',
        () async {
          const String loggedUserId = 'p1';
          final Player loggedUser = const PlayerCreator(
            id: loggedUserId,
            username: 'logged user',
          ).create();
          final List<SeasonGrandPrix> finishedSeasonGrandPrixes = [
            SeasonGrandPrixCreator(id: 'sgp1', roundNumber: 2).create(),
            SeasonGrandPrixCreator(id: 'sgp2', roundNumber: 3).create(),
            SeasonGrandPrixCreator(id: 'sgp3', roundNumber: 1).create(),
          ];
          final List<SeasonGrandPrixBetPoints> grandPrixesBetPoints = [
            SeasonGrandPrixBetPointsCreator(
              playerId: loggedUserId,
              seasonGrandPrixId: finishedSeasonGrandPrixes.first.id,
              totalPoints: 20,
            ).create(),
            SeasonGrandPrixBetPointsCreator(
              playerId: loggedUserId,
              seasonGrandPrixId: finishedSeasonGrandPrixes[1].id,
              totalPoints: 12.2,
            ).create(),
            SeasonGrandPrixBetPointsCreator(
              playerId: loggedUserId,
              seasonGrandPrixId: finishedSeasonGrandPrixes.last.id,
              totalPoints: 17,
            ).create(),
          ];
          final PointsHistory expectedPointsHistory = PointsHistory(
            players: [loggedUser],
            grandPrixes: const [
              PointsHistoryGrandPrix(
                roundNumber: 1,
                playersPoints: [
                  PointsHistoryPlayerPoints(
                    playerId: loggedUserId,
                    points: 17,
                  ),
                ],
              ),
              PointsHistoryGrandPrix(
                roundNumber: 2,
                playersPoints: [
                  PointsHistoryPlayerPoints(
                    playerId: loggedUserId,
                    points: 37,
                  ),
                ],
              ),
              PointsHistoryGrandPrix(
                roundNumber: 3,
                playersPoints: [
                  PointsHistoryPlayerPoints(
                    playerId: loggedUserId,
                    points: 49.2,
                  ),
                ],
              ),
            ],
          );
          authRepository.mockGetLoggedUserId(loggedUserId);
          playerRepository.mockGetById(player: loggedUser);
          getFinishedGrandPrixesFromSeasonUseCase.mock(
            finishedSeasonGrandPrixes: finishedSeasonGrandPrixes,
          );
          seasonGrandPrixBetPointsRepository
              .mockGetSeasonGrandPrixBetPointsForPlayersAndSeasonGrandPrixes(
            seasonGrandPrixesBetPoints: grandPrixesBetPoints,
          );

          final Stream<PointsHistory?> pointsHistory$ =
              createPointsHistoryStats(
            statsType: statsType,
            season: season,
          );

          expect(await pointsHistory$.first, expectedPointsHistory);
          verify(
            () => seasonGrandPrixBetPointsRepository
                .getSeasonGrandPrixBetPointsForPlayersAndSeasonGrandPrixes(
              season: season,
              idsOfPlayers: [loggedUserId],
              idsOfSeasonGrandPrixes:
                  finishedSeasonGrandPrixes.map((gp) => gp.id).toList(),
            ),
          ).called(1);
        },
      );
    },
  );
}
