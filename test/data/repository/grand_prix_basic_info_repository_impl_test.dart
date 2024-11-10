import 'package:betgrid/data/firebase/model/grand_prix_basic_info_dto.dart';
import 'package:betgrid/data/repository/grand_prix_basic_info/grand_prix_basic_info_repository_impl.dart';
import 'package:betgrid/model/grand_prix_basic_info.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../creator/grand_prix_basic_info_creator.dart';
import '../../mock/data/firebase/mock_firebase_grand_prix_basic_info_service.dart';
import '../../mock/data/mapper/mock_grand_prix_basic_info_mapper.dart';

void main() {
  final firebaseGrandPrixBasicInfoService =
      MockFirebaseGrandPrixBasicInfoService();
  final grandPrixBasicInfoMapper = MockGrandPrixBasicInfoMapper();
  late GrandPrixBasicInfoRepositoryImpl repositoryImpl;

  setUp(() {
    repositoryImpl = GrandPrixBasicInfoRepositoryImpl(
      firebaseGrandPrixBasicInfoService,
      grandPrixBasicInfoMapper,
    );
  });

  tearDown(() {
    reset(firebaseGrandPrixBasicInfoService);
    reset(grandPrixBasicInfoMapper);
  });

  group(
    'getGrandPrixBasicInfoById',
    () {
      const String id = 'gp1';
      const grandPrixBasicInfoCreator = GrandPrixBasicInfoCreator(
        id: id,
        name: 'Grand prix',
        countryAlpha2Code: 'pl',
      );
      final List<GrandPrixBasicInfo> existingGrandPrixesBasicInfo = [
        const GrandPrixBasicInfoCreator(id: 'gp2').createEntity(),
        const GrandPrixBasicInfoCreator(id: 'gp3').createEntity(),
      ];

      test(
        'should fetch grand prix basic info from db, add it to repo state and '
        'emit it if there are no matching grand prix basic info in repo state',
        () async {
          final GrandPrixBasicInfoDto expectedGrandPrixBasicInfoDto =
              grandPrixBasicInfoCreator.createDto();
          final GrandPrixBasicInfo expectedGrandPrixBasicInfo =
              grandPrixBasicInfoCreator.createEntity();
          firebaseGrandPrixBasicInfoService.mockFetchGrandPrixBasicInfoById(
            expectedGrandPrixBasicInfoDto: expectedGrandPrixBasicInfoDto,
          );
          grandPrixBasicInfoMapper.mockMapFromDto(
            expectedGrandPrixBasicInfo: expectedGrandPrixBasicInfo,
          );
          repositoryImpl.addEntities(existingGrandPrixesBasicInfo);

          final Stream<GrandPrixBasicInfo?> grandPrixBasicInfo$ =
              repositoryImpl.getGrandPrixBasicInfoById(id);

          expect(await grandPrixBasicInfo$.first, expectedGrandPrixBasicInfo);
          expect(
            await repositoryImpl.repositoryState$.first,
            [...existingGrandPrixesBasicInfo, expectedGrandPrixBasicInfo],
          );
          verify(
            () => firebaseGrandPrixBasicInfoService
                .fetchGrandPrixBasicInfoById(id),
          ).called(1);
        },
      );

      test(
        'should only emit driver personal data if it already exists in repo '
        'state',
        () async {
          final GrandPrixBasicInfo expectedGrandPrixBasicInfo =
              grandPrixBasicInfoCreator.createEntity();
          repositoryImpl.addEntities(
            [...existingGrandPrixesBasicInfo, expectedGrandPrixBasicInfo],
          );

          final Stream<GrandPrixBasicInfo?> grandPrixBasicInfo$ =
              repositoryImpl.getGrandPrixBasicInfoById(id);

          expect(await grandPrixBasicInfo$.first, expectedGrandPrixBasicInfo);
        },
      );
    },
  );
}
