import 'package:betgrid/data/mapper/grand_prix_basic_info_mapper.dart';
import 'package:betgrid/model/grand_prix_basic_info.dart';
import 'package:mocktail/mocktail.dart';

import '../../../creator/grand_prix_basic_info_creator.dart';

class MockGrandPrixBasicInfoMapper extends Mock
    implements GrandPrixBasicInfoMapper {
  MockGrandPrixBasicInfoMapper() {
    registerFallbackValue(
      const GrandPrixBasicInfoCreator().createDto(),
    );
  }

  void mockMapFromDto({
    required GrandPrixBasicInfo expectedGrandPrixBasicInfo,
  }) {
    when(
      () => mapFromDto(any()),
    ).thenReturn(expectedGrandPrixBasicInfo);
  }
}
