import 'package:betgrid/data/firebase/model/team_dto.dart';
import 'package:betgrid/data/repository/team/team_repository_impl.dart';
import 'package:betgrid/model/team.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../creator/team_creator.dart';
import '../../mock/data/firebase/mock_firebase_team_service.dart';
import '../../mock/data/mapper/mock_team_mapper.dart';

void main() {
  final firebaseTeamService = MockFirebaseTeamService();
  final teamMapper = MockNewTeamMapper();
  late TeamRepositoryImpl repositoryImpl;

  setUp(() {
    repositoryImpl = TeamRepositoryImpl(firebaseTeamService, teamMapper);
  });

  tearDown(() {
    reset(firebaseTeamService);
    reset(teamMapper);
  });

  group(
    'getTeamById, ',
    () {
      const String teamId = 'd1';
      const TeamCreator teamCreator = TeamCreator(
        id: teamId,
        name: 'Mercedes',
        hexColor: '#FFFFFF',
      );
      final List<Team> existingTeams = [
        const TeamCreator(id: 'd2').createEntity(),
        const TeamCreator(id: 'd3').createEntity(),
      ];

      test(
        'should fetch team from db, add it to repo state and emit it if '
        'team does not exist in repo state',
        () async {
          final TeamDto expectedTeamDto = teamCreator.createDto();
          final Team expectedTeam = teamCreator.createEntity();
          firebaseTeamService.mockFetchTeamById(
            expectedTeamDto: expectedTeamDto,
          );
          teamMapper.mockMapFromDto(expectedTeam: expectedTeam);
          repositoryImpl.addEntities(existingTeams);

          final Stream<Team?> team$ = repositoryImpl.getTeamById(
            expectedTeam.id,
          );

          expect(await team$.first, expectedTeam);
          expect(
            await repositoryImpl.repositoryState$.first,
            [...existingTeams, expectedTeam],
          );
          verify(
            () => firebaseTeamService.fetchTeamById(expectedTeam.id),
          ).called(1);
        },
      );

      test(
        'should only emit team if it already exists in repo state',
        () async {
          final Team expectedTeam = teamCreator.createEntity();
          repositoryImpl.addEntities(
            [...existingTeams, expectedTeam],
          );

          final Stream<Team?> team$ = repositoryImpl.getTeamById(
            expectedTeam.id,
          );

          expect(await team$.first, expectedTeam);
        },
      );
    },
  );
}
