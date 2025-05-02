import 'season_entity.dart';

class SeasonTeam extends SeasonEntity {
  final String teamId;

  const SeasonTeam({
    required super.id,
    required super.season,
    required this.teamId,
  });

  @override
  List<Object?> get props => [id, season, teamId];
}
