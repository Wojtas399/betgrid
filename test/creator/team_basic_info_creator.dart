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

  TeamBasicInfo create() {
    return TeamBasicInfo(
      id: id,
      name: name,
      hexColor: hexColor,
    );
  }
}
