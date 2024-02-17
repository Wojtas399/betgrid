import 'package:betgrid/data/repository/grand_prix/grand_prix_repository_impl.dart';
import 'package:betgrid/firebase/model/grand_prix_dto/grand_prix_dto.dart';
import 'package:betgrid/firebase/service/firebase_grand_prix_service.dart';
import 'package:betgrid/model/grand_prix.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';

import '../../mock/firebase/mock_firebase_grand_prix_service.dart';

void main() {
  final dbGrandPrixService = MockFirebaseGrandPrixService();
  late GrandPrixRepositoryImpl repositoryImpl;

  setUpAll(() {
    GetIt.I.registerFactory<FirebaseGrandPrixService>(
      () => dbGrandPrixService,
    );
  });

  setUp(() {
    repositoryImpl = GrandPrixRepositoryImpl();
  });

  tearDown(() {
    reset(dbGrandPrixService);
  });

  test(
    'loadAllGrandPrixes, '
    'should load grand prixes from db, add them to repo and return them',
    () async {
      final List<GrandPrixDto> grandPrixDtos = [
        GrandPrixDto(
          id: 'gp1',
          name: 'Grand Prix 1',
          countryAlpha2Code: 'BH',
          startDate: DateTime(2023, 1, 2),
          endDate: DateTime(2023, 1, 4),
        ),
        GrandPrixDto(
          id: 'gp2',
          name: 'Grand Prix 2',
          countryAlpha2Code: 'PL',
          startDate: DateTime(2023, 1, 10),
          endDate: DateTime(2023, 1, 12),
        ),
        GrandPrixDto(
          id: 'gp3',
          name: 'Grand Prix 3',
          countryAlpha2Code: 'XD',
          startDate: DateTime(2023, 1, 20),
          endDate: DateTime(2023, 1, 22),
        ),
      ];
      final List<GrandPrix> expectedGrandPrixes = [
        GrandPrix(
          id: 'gp1',
          name: 'Grand Prix 1',
          countryAlpha2Code: 'BH',
          startDate: DateTime(2023, 1, 2),
          endDate: DateTime(2023, 1, 4),
        ),
        GrandPrix(
          id: 'gp2',
          name: 'Grand Prix 2',
          countryAlpha2Code: 'PL',
          startDate: DateTime(2023, 1, 10),
          endDate: DateTime(2023, 1, 12),
        ),
        GrandPrix(
          id: 'gp3',
          name: 'Grand Prix 3',
          countryAlpha2Code: 'XD',
          startDate: DateTime(2023, 1, 20),
          endDate: DateTime(2023, 1, 22),
        ),
      ];
      dbGrandPrixService.mockLoadAllGrandPrixes(
        grandPrixDtos: grandPrixDtos,
      );

      final List<GrandPrix> grandPrixes =
          await repositoryImpl.loadAllGrandPrixes();

      expect(grandPrixes, expectedGrandPrixes);
      expect(repositoryImpl.repositoryState$, emits(expectedGrandPrixes));
      verify(dbGrandPrixService.loadAllGrandPrixes).called(1);
    },
  );

  test(
    'loadGrandPrixById, '
    'grand prix exists in repository state, '
    'should return grand prix from repository state',
    () async {
      const String grandPrixId = 'gp2';
      final List<GrandPrix> existingGrandPrixes = [
        GrandPrix(
          id: 'gp1',
          name: 'Grand Prix 1',
          countryAlpha2Code: 'BH',
          startDate: DateTime(2023, 1, 2),
          endDate: DateTime(2023, 1, 4),
        ),
        GrandPrix(
          id: grandPrixId,
          name: 'Grand Prix 2',
          countryAlpha2Code: 'PL',
          startDate: DateTime(2023, 1, 10),
          endDate: DateTime(2023, 1, 12),
        ),
        GrandPrix(
          id: 'gp3',
          name: 'Grand Prix 3',
          countryAlpha2Code: 'XD',
          startDate: DateTime(2023, 1, 20),
          endDate: DateTime(2023, 1, 22),
        ),
      ];
      repositoryImpl = GrandPrixRepositoryImpl(
        initialData: existingGrandPrixes,
      );

      final GrandPrix? grandPrix = await repositoryImpl.loadGrandPrixById(
        grandPrixId: grandPrixId,
      );

      expect(grandPrix, existingGrandPrixes[1]);
    },
  );

  test(
    'loadGrandPrixById, '
    'grand prix does not exist in repository state, '
    'should load grand prix from db, add it to repository state and return it',
    () async {
      const String grandPrixId = 'gp2';
      final GrandPrixDto grandPrixDto = GrandPrixDto(
        id: grandPrixId,
        name: 'Grand Prix 2',
        countryAlpha2Code: 'PL',
        startDate: DateTime(2023, 1, 10),
        endDate: DateTime(2023, 1, 12),
      );
      final GrandPrix expectedGrandPrix = GrandPrix(
        id: grandPrixId,
        name: 'Grand Prix 2',
        countryAlpha2Code: 'PL',
        startDate: DateTime(2023, 1, 10),
        endDate: DateTime(2023, 1, 12),
      );
      final List<GrandPrix> existingGrandPrixes = [
        GrandPrix(
          id: 'gp1',
          name: 'Grand Prix 1',
          countryAlpha2Code: 'BH',
          startDate: DateTime(2023, 1, 2),
          endDate: DateTime(2023, 1, 4),
        ),
        GrandPrix(
          id: 'gp3',
          name: 'Grand Prix 3',
          countryAlpha2Code: 'XD',
          startDate: DateTime(2023, 1, 20),
          endDate: DateTime(2023, 1, 22),
        ),
      ];
      dbGrandPrixService.mockLoadGrandPrixById(grandPrixDto);
      repositoryImpl = GrandPrixRepositoryImpl(
        initialData: existingGrandPrixes,
      );

      final GrandPrix? grandPrix = await repositoryImpl.loadGrandPrixById(
        grandPrixId: grandPrixId,
      );

      expect(grandPrix, expectedGrandPrix);
      expect(
        repositoryImpl.repositoryState$,
        emits([
          ...existingGrandPrixes,
          expectedGrandPrix,
        ]),
      );
      verify(
        () => dbGrandPrixService.loadGrandPrixById(grandPrixId: grandPrixId),
      ).called(1);
    },
  );
}
