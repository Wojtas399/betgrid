import 'package:betgrid/data/mapper/team_basic_info_mapper.dart';
import 'package:betgrid/model/team_basic_info.dart';
import 'package:mocktail/mocktail.dart';

import '../../../creator/team_basic_info_creator.dart';

class MockTeamBasicInfoMapper extends Mock implements TeamBasicInfoMapper {
  MockTeamBasicInfoMapper() {
    registerFallbackValue(
      const TeamBasicInfoCreator().createDto(),
    );
  }

  void mockMapFromDto({
    required TeamBasicInfo expectedTeamBasicInfo,
  }) {
    when(
      () => mapFromDto(any()),
    ).thenReturn(expectedTeamBasicInfo);
  }
}
