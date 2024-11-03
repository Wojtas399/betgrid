import 'package:betgrid/data/firebase/model/team_dto.dart';
import 'package:betgrid/model/team.dart';

class TeamCreator {
  final String id;
  final String name;
  final String hexColor;

  const TeamCreator({
    this.id = '',
    this.name = '',
    this.hexColor = '',
  });

  Team createEntity() {
    return Team(
      id: id,
      name: name,
      hexColor: hexColor,
    );
  }

  TeamDto createDto() {
    return TeamDto(
      id: id,
      name: name,
      hexColor: hexColor,
    );
  }

  Map<String, Object?> createJson() {
    return {
      'name': name,
      'hexColor': hexColor,
    };
  }
}
