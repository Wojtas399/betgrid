import 'package:betgrid_shared/firebase/model/season_team_dto.dart';
import 'package:betgrid_shared/firebase/service/firebase_season_team_service.dart';
import 'package:injectable/injectable.dart';

import '../../../model/season_team.dart';
import '../../mapper/season_team_mapper.dart';
import '../repository.dart';
import 'season_team_repository.dart';

@LazySingleton(as: SeasonTeamRepository)
class SeasonTeamRepositoryImpl extends Repository<SeasonTeam>
    implements SeasonTeamRepository {
  final FirebaseSeasonTeamService _firebaseSeasonTeamService;
  final SeasonTeamMapper _seasonTeamMapper;

  SeasonTeamRepositoryImpl(
    this._firebaseSeasonTeamService,
    this._seasonTeamMapper,
  );

  @override
  Stream<List<SeasonTeam>> getAllFromSeason(int season) async* {
    await _fetchAllFromSeason(season);
    await for (final allTeams in repositoryState$) {
      yield allTeams.where((team) => team.season == season).toList();
    }
  }

  @override
  Future<void> add({required int season, required String teamId}) async {
    final SeasonTeamDto? addedSeasonTeamDto = await _firebaseSeasonTeamService
        .add(season: season, teamId: teamId);
    if (addedSeasonTeamDto != null) {
      final SeasonTeam addedSeasonTeam = _seasonTeamMapper.mapFromDto(
        addedSeasonTeamDto,
      );
      addEntity(addedSeasonTeam);
    }
  }

  @override
  Future<void> delete({
    required int season,
    required String seasonTeamId,
  }) async {
    await _firebaseSeasonTeamService.delete(
      season: season,
      seasonTeamId: seasonTeamId,
    );
    deleteEntity(seasonTeamId);
  }

  Future<void> _fetchAllFromSeason(int season) async {
    final Iterable<SeasonTeamDto> dtos = await _firebaseSeasonTeamService
        .fetchAllTeamsFromSeason(season);
    if (dtos.isNotEmpty) {
      final Iterable<SeasonTeam> entities = dtos.map(
        _seasonTeamMapper.mapFromDto,
      );
      addOrUpdateEntities(entities);
    }
  }
}
