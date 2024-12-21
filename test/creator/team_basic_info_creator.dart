import 'package:betgrid/data/firebase/model/team_basic_info_dto.dart';
import 'package:betgrid/model/team_basic_info.dart';

class TeamBasicInfoCreator {
  final String id;
  final String name;
  final String hexColor;

  const TeamBasicInfoCreator({
    this.id = '',
    this.name = '',
    this.hexColor = '',
  });

  TeamBasicInfo createEntity() {
    return TeamBasicInfo(
      id: id,
      name: name,
      hexColor: hexColor,
    );
  }

  TeamBasicInfoDto createDto() {
    return TeamBasicInfoDto(
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
