import 'package:betgrid/data/firebase/model/grand_prix_basic_info_dto.dart';

class GrandPrixBasicInfoCreator {
  final String id;
  final String name;
  final String countryAlpha2Code;

  const GrandPrixBasicInfoCreator({
    this.id = '',
    this.name = '',
    this.countryAlpha2Code = '',
  });

  GrandPrixBasicInfoDto createDto() {
    return GrandPrixBasicInfoDto(
      id: id,
      name: name,
      countryAlpha2Code: countryAlpha2Code,
    );
  }

  Map<String, Object?> createJson() {
    return {
      'name': name,
      'countryAlpha2Code': countryAlpha2Code,
    };
  }
}
