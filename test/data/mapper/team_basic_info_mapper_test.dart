import 'package:betgrid/data/mapper/team_basic_info_mapper.dart';
import 'package:betgrid/model/team_basic_info.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../creator/team_basic_info_creator.dart';

void main() {
  final mapper = TeamBasicInfoMapper();

  test(
    'mapFromDto, '
    'should map TeamDto model to Team model',
    () {
      const String id = 't1';
      const String name = 'mercedes';
      const String hexColor = '#FFFFFF';
      const teamBasicInfoCreator = TeamBasicInfoCreator(
        id: id,
        name: name,
        hexColor: hexColor,
      );
      final teamBasicInfoDto = teamBasicInfoCreator.createDto();
      final expectedTeamBasicInfo = teamBasicInfoCreator.createEntity();

      final TeamBasicInfo teamBasicInfo = mapper.mapFromDto(teamBasicInfoDto);

      expect(teamBasicInfo, expectedTeamBasicInfo);
    },
  );
}
