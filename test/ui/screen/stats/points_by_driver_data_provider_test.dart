import 'package:betgrid/data/repository/player/player_repository_method_providers.dart';
import 'package:betgrid/model/grand_prix.dart';
import 'package:betgrid/model/player.dart';
import 'package:betgrid/ui/screen/stats/provider/finished_grand_prixes_provider.dart';
import 'package:betgrid/ui/screen/stats/provider/points_by_driver_data_provider.dart';
import 'package:betgrid/ui/screen/stats/provider/points_for_driver_in_grand_prix_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../creator/grand_prix_creator.dart';
import '../../../mock/listener.dart';

void main() {
  ProviderContainer makeProviderContainer({
    List<Player>? allPlayers,
    List<GrandPrix> finishedGrandPrixes = const [],
  }) {
    final container = ProviderContainer(
      overrides: [
        allPlayersProvider.overrideWith((_) => Stream.value(allPlayers)),
        finishedGrandPrixesProvider.overrideWith(
          (_) => Future.value(finishedGrandPrixes),
        ),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  setUpAll(() {
    registerFallbackValue(
      const AsyncLoading<List<PointsByDriverPlayerPoints>>(),
    );
  });

  test(
    'build, '
    'should return empty list',
    () async {
      final container = makeProviderContainer();

      final playersPoints = await container.read(
        pointsByDriverDataProviderProvider.future,
      );

      expect(playersPoints, []);
    },
  );

  test(
    'onDriverChanged, '
    'list of all players does not exist, '
    'should set state as empty list',
    () async {
      const String driverId = 'd1';
      final container = makeProviderContainer();
      final listener = Listener<AsyncValue<List<PointsByDriverPlayerPoints>>>();

      container.listen(
        pointsByDriverDataProviderProvider,
        listener,
        fireImmediately: true,
      );
      await container.read(pointsByDriverDataProviderProvider.future);
      container
          .read(pointsByDriverDataProviderProvider.notifier)
          .onDriverChanged(driverId);
      final playersPoints = await container.read(
        pointsByDriverDataProviderProvider.future,
      );

      expect(playersPoints, []);
      verifyInOrder([
        () => listener(
              null,
              const AsyncLoading<List<PointsByDriverPlayerPoints>>(),
            ),
        () => listener(
              any(that: isA<AsyncLoading>()),
              any(that: isA<AsyncData>()),
            ),
        () => listener(
              any(that: isA<AsyncData>()),
              any(that: isA<AsyncLoading>()),
            ),
        () => listener(
              any(that: isA<AsyncLoading>()),
              any(that: isA<AsyncData>()),
            ),
      ]);
      verifyNoMoreInteractions(listener);
    },
  );

  test(
    'onDriverChanged, '
    'list of all players is empty, '
    'should set state as empty list',
    () async {
      const String driverId = 'd1';
      final container = makeProviderContainer(
        allPlayers: [],
      );
      final listener = Listener<AsyncValue<List<PointsByDriverPlayerPoints>>>();

      container.listen(
        pointsByDriverDataProviderProvider,
        listener,
        fireImmediately: true,
      );
      await container.read(pointsByDriverDataProviderProvider.future);
      container
          .read(pointsByDriverDataProviderProvider.notifier)
          .onDriverChanged(driverId);
      final playersPoints = await container.read(
        pointsByDriverDataProviderProvider.future,
      );

      expect(playersPoints, []);
      verifyInOrder([
        () => listener(
              null,
              const AsyncLoading<List<PointsByDriverPlayerPoints>>(),
            ),
        () => listener(
              any(that: isA<AsyncLoading>()),
              any(that: isA<AsyncData>()),
            ),
        () => listener(
              any(that: isA<AsyncData>()),
              any(that: isA<AsyncLoading>()),
            ),
        () => listener(
              any(that: isA<AsyncLoading>()),
              any(that: isA<AsyncData>()),
            ),
      ]);
      verifyNoMoreInteractions(listener);
    },
  );

  test(
    'onDriverChanged, '
    'list of all grand prixes is empty, '
    'should set list of players with 0.0 points for each of them',
    () async {
      const String driverId = 'd1';
      const List<Player> allPlayers = [
        Player(id: 'p1', username: 'username 1'),
        Player(id: 'p2', username: 'username 2'),
      ];
      final List<PointsByDriverPlayerPoints> expectedPlayersPoints = [
        PointsByDriverPlayerPoints(player: allPlayers.first, points: 0),
        PointsByDriverPlayerPoints(player: allPlayers.last, points: 0),
      ];
      final container = makeProviderContainer(
        allPlayers: allPlayers,
      );
      final listener = Listener<AsyncValue<List<PointsByDriverPlayerPoints>>>();

      container.listen(
        pointsByDriverDataProviderProvider,
        listener,
        fireImmediately: true,
      );
      await container.read(pointsByDriverDataProviderProvider.future);
      container
          .read(pointsByDriverDataProviderProvider.notifier)
          .onDriverChanged(driverId);
      final playersPoints = await container.read(
        pointsByDriverDataProviderProvider.future,
      );

      expect(playersPoints, expectedPlayersPoints);
      verifyInOrder([
        () => listener(
              null,
              const AsyncLoading<List<PointsByDriverPlayerPoints>>(),
            ),
        () => listener(
              any(that: isA<AsyncLoading>()),
              any(that: isA<AsyncData>()),
            ),
        () => listener(
              any(that: isA<AsyncData>()),
              any(that: isA<AsyncLoading>()),
            ),
        () => listener(
              any(that: isA<AsyncLoading>()),
              any(that: isA<AsyncData>()),
            ),
      ]);
      verifyNoMoreInteractions(listener);
    },
  );

  test(
    'onDriverChanged, '
    'for each player should sum points received for driver in each gp',
    () async {
      const String driverId = 'd1';
      const List<Player> allPlayers = [
        Player(id: 'p1', username: 'username 1'),
        Player(id: 'p2', username: 'username 2'),
      ];
      final List<GrandPrix> finishedGrandPrixes = [
        createGrandPrix(id: 'gp1'),
        createGrandPrix(id: 'gp2'),
        createGrandPrix(id: 'gp3'),
      ];
      const double p1Gp1Points = 5.0;
      const double p1Gp2Points = 7.5;
      const double p1Gp3Points = 10.2;
      const double p2Gp1Points = 4.4;
      const double p2Gp2Points = 7.0;
      const double p2Gp3Points = 9.0;
      final List<PointsByDriverPlayerPoints> expectedPlayersPoints = [
        PointsByDriverPlayerPoints(
          player: allPlayers.first,
          points: p1Gp1Points + p1Gp2Points + p1Gp3Points,
        ),
        PointsByDriverPlayerPoints(
          player: allPlayers.last,
          points: p2Gp1Points + p2Gp2Points + p2Gp3Points,
        ),
      ];
      final container = ProviderContainer(
        overrides: [
          allPlayersProvider.overrideWith((_) => Stream.value(allPlayers)),
          finishedGrandPrixesProvider.overrideWith(
            (_) => Future.value(finishedGrandPrixes),
          ),
          pointsForDriverInGrandPrixProvider(
            playerId: 'p1',
            grandPrixId: 'gp1',
            driverId: driverId,
          ).overrideWith((_) => Future.value(p1Gp1Points)),
          pointsForDriverInGrandPrixProvider(
            playerId: 'p1',
            grandPrixId: 'gp2',
            driverId: driverId,
          ).overrideWith((_) => Future.value(p1Gp2Points)),
          pointsForDriverInGrandPrixProvider(
            playerId: 'p1',
            grandPrixId: 'gp3',
            driverId: driverId,
          ).overrideWith((_) => Future.value(p1Gp3Points)),
          pointsForDriverInGrandPrixProvider(
            playerId: 'p2',
            grandPrixId: 'gp1',
            driverId: driverId,
          ).overrideWith((_) => Future.value(p2Gp1Points)),
          pointsForDriverInGrandPrixProvider(
            playerId: 'p2',
            grandPrixId: 'gp2',
            driverId: driverId,
          ).overrideWith((_) => Future.value(p2Gp2Points)),
          pointsForDriverInGrandPrixProvider(
            playerId: 'p2',
            grandPrixId: 'gp3',
            driverId: driverId,
          ).overrideWith((_) => Future.value(p2Gp3Points)),
        ],
      );
      final listener = Listener<AsyncValue<List<PointsByDriverPlayerPoints>>>();

      container.listen(
        pointsByDriverDataProviderProvider,
        listener,
        fireImmediately: true,
      );
      await container.read(pointsByDriverDataProviderProvider.future);
      container
          .read(pointsByDriverDataProviderProvider.notifier)
          .onDriverChanged(driverId);
      final playersPoints = await container.read(
        pointsByDriverDataProviderProvider.future,
      );

      expect(playersPoints, expectedPlayersPoints);
      verifyInOrder([
        () => listener(
              null,
              const AsyncLoading<List<PointsByDriverPlayerPoints>>(),
            ),
        () => listener(
              any(that: isA<AsyncLoading>()),
              any(that: isA<AsyncData>()),
            ),
        () => listener(
              any(that: isA<AsyncData>()),
              any(that: isA<AsyncLoading>()),
            ),
        () => listener(
              any(that: isA<AsyncLoading>()),
              any(that: isA<AsyncData>()),
            ),
      ]);
      verifyNoMoreInteractions(listener);
    },
  );
}
