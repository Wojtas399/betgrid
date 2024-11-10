import 'package:betgrid/data/mapper/grand_prix_basic_info_mapper.dart';
import 'package:betgrid/model/grand_prix_basic_info.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../creator/grand_prix_basic_info_creator.dart';

void main() {
  final mapper = GrandPrixBasicInfoMapper();

  test(
    'mapFromDto, '
    'should map GrandPrixBasicInfoDto model to GrandPrixBasicInfo model',
    () {
      const String id = 'gp1';
      const String name = 'Monaco GP';
      const String countryAlpha2Code = 'PL';
      const creator = GrandPrixBasicInfoCreator(
        id: id,
        name: name,
        countryAlpha2Code: countryAlpha2Code,
      );
      final grandPrixBasicInfoDto = creator.createDto();
      final grandPrixBasicInfo = creator.createEntity();

      final GrandPrixBasicInfo mappedModel =
          mapper.mapFromDto(grandPrixBasicInfoDto);

      expect(mappedModel, grandPrixBasicInfo);
    },
  );
}
