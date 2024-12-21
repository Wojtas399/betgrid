import 'package:betgrid/data/firebase/model/team_basic_info_dto.dart';
import 'package:betgrid/data/repository/team_basic_info/team_basic_info_repository_impl.dart';
import 'package:betgrid/model/team_basic_info.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../creator/team_basic_info_creator.dart';
import '../../mock/data/firebase/mock_firebase_team_basic_info_service.dart';
import '../../mock/data/mapper/mock_team_basic_info_mapper.dart';

void main() {
  final firebaseTeamBasicInfoService = MockFirebaseTeamBasicInfoService();
  final teamBasicInfoMapper = MockTeamBasicInfoMapper();
  late TeamBasicInfoRepositoryImpl repositoryImpl;

  setUp(() {
    repositoryImpl = TeamBasicInfoRepositoryImpl(
      firebaseTeamBasicInfoService,
      teamBasicInfoMapper,
    );
  });

  tearDown(() {
    reset(firebaseTeamBasicInfoService);
    reset(teamBasicInfoMapper);
  });

  group(
    'getTeamById, ',
    () {
      const String teamId = 'd1';
      const TeamBasicInfoCreator teamBasicInfoCreator = TeamBasicInfoCreator(
        id: teamId,
        name: 'Mercedes',
        hexColor: '#FFFFFF',
      );
      final List<TeamBasicInfo> existingTeams = [
        const TeamBasicInfoCreator(id: 'd2').createEntity(),
        const TeamBasicInfoCreator(id: 'd3').createEntity(),
      ];

      test(
        'should fetch team from db, add it to repo state and emit it if '
        'team does not exist in repo state',
        () async {
          final TeamBasicInfoDto expectedTeamBasicInfoDto =
              teamBasicInfoCreator.createDto();
          final TeamBasicInfo expectedTeamBasicInfo =
              teamBasicInfoCreator.createEntity();
          firebaseTeamBasicInfoService.mockFetchTeamBasicInfoById(
            expectedTeamBasicInfoDto: expectedTeamBasicInfoDto,
          );
          teamBasicInfoMapper.mockMapFromDto(
            expectedTeamBasicInfo: expectedTeamBasicInfo,
          );
          repositoryImpl.addEntities(existingTeams);

          final Stream<TeamBasicInfo?> team$ =
              repositoryImpl.getTeamBasicInfoById(
            expectedTeamBasicInfo.id,
          );

          expect(await team$.first, expectedTeamBasicInfo);
          expect(
            await repositoryImpl.repositoryState$.first,
            [...existingTeams, expectedTeamBasicInfo],
          );
          verify(
            () => firebaseTeamBasicInfoService.fetchTeamBasicInfoById(
              expectedTeamBasicInfo.id,
            ),
          ).called(1);
        },
      );

      test(
        'should only emit team if it already exists in repo state',
        () async {
          final TeamBasicInfo expectedTeamBasicInfo =
              teamBasicInfoCreator.createEntity();
          repositoryImpl.addEntities(
            [...existingTeams, expectedTeamBasicInfo],
          );

          final Stream<TeamBasicInfo?> team$ =
              repositoryImpl.getTeamBasicInfoById(
            expectedTeamBasicInfo.id,
          );

          expect(await team$.first, expectedTeamBasicInfo);
        },
      );
    },
  );
}
