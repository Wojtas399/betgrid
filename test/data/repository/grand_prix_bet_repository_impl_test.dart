import 'package:betgrid/data/repository/grand_prix_bet/grand_prix_bet_repository_impl.dart';
import 'package:betgrid/firebase/model/grand_prix_bet/grand_prix_bet_dto.dart';
import 'package:betgrid/firebase/service/firebase_grand_prix_bet_service.dart';
import 'package:betgrid/model/grand_prix_bet.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';

import '../../creator/grand_prix_bet_creator.dart';
import '../../creator/grand_prix_bet_dto_creator.dart';
import '../../mock/firebase/mock_firebase_grand_prix_bet_service.dart';

void main() {
  final dbGrandPrixBetService = MockFirebaseGrandPrixBetService();
  late GrandPrixBetRepositoryImpl repositoryImpl;
  const String userId = 'u1';

  setUpAll(() {
    GetIt.I.registerFactory<FirebaseGrandPrixBetService>(
      () => dbGrandPrixBetService,
    );
  });

  setUp(() {
    repositoryImpl = GrandPrixBetRepositoryImpl();
  });

  tearDown(() {
    reset(dbGrandPrixBetService);
  });

  test(
    'getAllGrandPrixBets, '
    'repository state is not set, '
    'should load grand prix bets from db, add them to repo and emit them',
    () async {
      final List<GrandPrixBetDto> grandPrixBetDtos = [
        createGrandPrixBetDto(id: 'gpb1', grandPrixId: 'gp1'),
        createGrandPrixBetDto(id: 'gpb2', grandPrixId: 'gp2'),
        createGrandPrixBetDto(id: 'gpb3', grandPrixId: 'gp3'),
      ];
      final List<GrandPrixBet> expectedGrandPrixBets = [
        createGrandPrixBet(id: 'gpb1', grandPrixId: 'gp1'),
        createGrandPrixBet(id: 'gpb2', grandPrixId: 'gp2'),
        createGrandPrixBet(id: 'gpb3', grandPrixId: 'gp3'),
      ];
      dbGrandPrixBetService.mockLoadAllGrandPrixBets(grandPrixBetDtos);

      final Stream<List<GrandPrixBet>?> grandPrixBets$ =
          repositoryImpl.getAllGrandPrixBets(userId: userId);

      expect(grandPrixBets$, emits(expectedGrandPrixBets));
      expect(
        repositoryImpl.repositoryState$,
        emitsInOrder([null, expectedGrandPrixBets]),
      );
      await repositoryImpl.repositoryState$.first;
      verify(
        () => dbGrandPrixBetService.loadAllGrandPrixBets(userId: userId),
      ).called(1);
    },
  );

  test(
    'getAllGrandPrixBets, '
    'repository state is empty array, '
    'should load grand prix bets from db, add them to repo and emit them',
    () async {
      final List<GrandPrixBetDto> grandPrixBetDtos = [
        createGrandPrixBetDto(id: 'gpb1', grandPrixId: 'gp1'),
        createGrandPrixBetDto(id: 'gpb2', grandPrixId: 'gp2'),
        createGrandPrixBetDto(id: 'gpb3', grandPrixId: 'gp3'),
      ];
      final List<GrandPrixBet> expectedGrandPrixBets = [
        createGrandPrixBet(id: 'gpb1', grandPrixId: 'gp1'),
        createGrandPrixBet(id: 'gpb2', grandPrixId: 'gp2'),
        createGrandPrixBet(id: 'gpb3', grandPrixId: 'gp3'),
      ];
      dbGrandPrixBetService.mockLoadAllGrandPrixBets(grandPrixBetDtos);
      repositoryImpl = GrandPrixBetRepositoryImpl(initialData: []);

      final Stream<List<GrandPrixBet>?> grandPrixBets$ =
          repositoryImpl.getAllGrandPrixBets(userId: userId);

      expect(grandPrixBets$, emits(expectedGrandPrixBets));
      expect(
        repositoryImpl.repositoryState$,
        emitsInOrder([[], expectedGrandPrixBets]),
      );
      await repositoryImpl.repositoryState$.first;
      verify(
        () => dbGrandPrixBetService.loadAllGrandPrixBets(userId: userId),
      ).called(1);
    },
  );

  test(
    'getAllGrandPrixBets, '
    'repository state contains grand prix bets, '
    'should only emit grand prix bets from repository state',
    () async {
      final List<GrandPrixBet> expectedGrandPrixBets = [
        createGrandPrixBet(id: 'gpb1', grandPrixId: 'gp1'),
        createGrandPrixBet(id: 'gpb2', grandPrixId: 'gp2'),
        createGrandPrixBet(id: 'gpb3', grandPrixId: 'gp3'),
      ];
      repositoryImpl = GrandPrixBetRepositoryImpl(
        initialData: expectedGrandPrixBets,
      );

      final Stream<List<GrandPrixBet>?> grandPrixBets$ =
          repositoryImpl.getAllGrandPrixBets(userId: userId);

      expect(grandPrixBets$, emits(expectedGrandPrixBets));
      expect(repositoryImpl.repositoryState$, emits(expectedGrandPrixBets));
      await repositoryImpl.repositoryState$.first;
      verifyNever(
        () => dbGrandPrixBetService.loadAllGrandPrixBets(userId: userId),
      );
    },
  );

  test(
    'getGrandPrixBetByGrandPrixId, '
    'bet with matching grand prix id exists in state, '
    'should return first matching grand prix',
    () async {
      final List<GrandPrixBet> grandPrixBets = [
        createGrandPrixBet(id: 'gpb1', grandPrixId: 'gp1'),
        createGrandPrixBet(id: 'gpb2', grandPrixId: 'gp2'),
        createGrandPrixBet(id: 'gpb3', grandPrixId: 'gp3'),
        createGrandPrixBet(id: 'gpb4', grandPrixId: 'gp1'),
      ];
      repositoryImpl = GrandPrixBetRepositoryImpl(initialData: grandPrixBets);

      final Stream<GrandPrixBet?> grandPrixBet$ =
          repositoryImpl.getGrandPrixBetByGrandPrixId(
        userId: userId,
        grandPrixId: 'gp1',
      );

      expect(grandPrixBet$, emits(grandPrixBets.first));
    },
  );

  test(
    'getGrandPrixBetByGrandPrixId, '
    'there is no bet with matching grand prix id in state, '
    'should load bet from db, add it to repository state and emit it',
    () async {
      const String grandPrixId = 'gp1';
      final GrandPrixBetDto grandPrixBetDto = createGrandPrixBetDto(
        id: 'gpb1',
        grandPrixId: grandPrixId,
      );
      const GrandPrixBet grandPrixBet = GrandPrixBet(
        id: 'gpb1',
        grandPrixId: grandPrixId,
      );
      final List<GrandPrixBet> grandPrixBets = [
        createGrandPrixBet(id: 'gpb2', grandPrixId: 'gp2'),
        createGrandPrixBet(id: 'gpb3', grandPrixId: 'gp3'),
      ];
      dbGrandPrixBetService.mockLoadGrandPrixBetByGrandPrixId(grandPrixBetDto);
      repositoryImpl = GrandPrixBetRepositoryImpl(initialData: grandPrixBets);

      final Stream<GrandPrixBet?> grandPrixBet$ =
          repositoryImpl.getGrandPrixBetByGrandPrixId(
        userId: userId,
        grandPrixId: grandPrixId,
      );

      expect(grandPrixBet$, emits(grandPrixBet));
      expect(
        repositoryImpl.repositoryState$,
        emitsInOrder([
          grandPrixBets,
          [...grandPrixBets, grandPrixBet],
        ]),
      );
      await repositoryImpl.repositoryState$.first;
      verify(
        () => dbGrandPrixBetService.loadGrandPrixBetByGrandPrixId(
          userId: userId,
          grandPrixId: grandPrixId,
        ),
      ).called(1);
    },
  );

  test(
    'addGrandPrixBets, '
    'for each grand prix bet should call db method to add this bet to db',
    () async {
      final List<GrandPrixBet> grandPrixBets = [
        createGrandPrixBet(id: 'gpb1'),
        createGrandPrixBet(id: 'gpb2'),
        createGrandPrixBet(id: 'gpb3'),
      ];
      final List<GrandPrixBetDto> grandPrixBetDtos = [
        createGrandPrixBetDto(id: grandPrixBets[0].id),
        createGrandPrixBetDto(id: grandPrixBets[1].id),
        createGrandPrixBetDto(id: grandPrixBets[2].id),
      ];
      dbGrandPrixBetService.mockAddGrandPrixBet();

      await repositoryImpl.addGrandPrixBets(
        userId: userId,
        grandPrixBets: grandPrixBets,
      );

      verify(
        () => dbGrandPrixBetService.addGrandPrixBet(
          userId: userId,
          grandPrixBetDto: grandPrixBetDtos[0],
        ),
      ).called(1);
      verify(
        () => dbGrandPrixBetService.addGrandPrixBet(
          userId: userId,
          grandPrixBetDto: grandPrixBetDtos[1],
        ),
      ).called(1);
      verify(
        () => dbGrandPrixBetService.addGrandPrixBet(
          userId: userId,
          grandPrixBetDto: grandPrixBetDtos[2],
        ),
      ).called(1);
    },
  );
}
