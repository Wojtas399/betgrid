import 'package:betgrid/data/repository/grand_prix/grand_prix_repository_impl.dart';
import 'package:betgrid/firebase/model/grand_prix_dto/grand_prix_dto.dart';
import 'package:betgrid/firebase/service/firebase_grand_prix_service.dart';
import 'package:betgrid/model/grand_prix.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';

import '../../mock/firebase/mock_firebase_grand_prix_service.dart';

void main() {
  final firebaseGrandPrixService = MockFirebaseGrandPrixService();
  late GrandPrixRepositoryImpl repositoryImpl;

  setUp(() {
    GetIt.I.registerFactory<FirebaseGrandPrixService>(
      () => firebaseGrandPrixService,
    );
  });

  setUp(() {
    repositoryImpl = GrandPrixRepositoryImpl();
  });

  tearDown(() {
    reset(firebaseGrandPrixService);
  });

  test(
    'getAllGrandPrixes, '
    'should load grand prix dtos from firebase and should return those '
    'dto models mapped to GrandPrix models',
    () async {
      final List<GrandPrixDto> grandPrixDtos = [
        GrandPrixDto(
          id: 'gp1',
          name: 'Grand Prix 1',
          startDate: DateTime(2023, 1, 2),
          endDate: DateTime(2023, 1, 4),
        ),
        GrandPrixDto(
          id: 'gp2',
          name: 'Grand Prix 2',
          startDate: DateTime(2023, 1, 10),
          endDate: DateTime(2023, 1, 12),
        ),
        GrandPrixDto(
          id: 'gp3',
          name: 'Grand Prix 3',
          startDate: DateTime(2023, 1, 20),
          endDate: DateTime(2023, 1, 22),
        ),
      ];
      final List<GrandPrix> expectedGrandPrixes = [
        GrandPrix(
          id: 'gp1',
          name: 'Grand Prix 1',
          startDate: DateTime(2023, 1, 2),
          endDate: DateTime(2023, 1, 4),
        ),
        GrandPrix(
          id: 'gp2',
          name: 'Grand Prix 2',
          startDate: DateTime(2023, 1, 10),
          endDate: DateTime(2023, 1, 12),
        ),
        GrandPrix(
          id: 'gp3',
          name: 'Grand Prix 3',
          startDate: DateTime(2023, 1, 20),
          endDate: DateTime(2023, 1, 22),
        ),
      ];
      firebaseGrandPrixService.mockLoadAllGrandPrixes(
        grandPrixDtos: grandPrixDtos,
      );

      final List<GrandPrix> grandPrixes =
          await repositoryImpl.loadAllGrandPrixes();

      expect(grandPrixes, expectedGrandPrixes);
      verify(firebaseGrandPrixService.loadAllGrandPrixes).called(1);
    },
  );
}
