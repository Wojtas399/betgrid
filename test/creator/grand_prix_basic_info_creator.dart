import 'package:betgrid/model/grand_prix_basic_info.dart';

class GrandPrixBasicInfoCreator {
  final String id;
  final String name;
  final String countryAlpha2Code;

  const GrandPrixBasicInfoCreator({
    this.id = '',
    this.name = '',
    this.countryAlpha2Code = '',
  });

  GrandPrixBasicInfo create() {
    return GrandPrixBasicInfo(
      id: id,
      name: name,
      countryAlpha2Code: countryAlpha2Code,
    );
  }
}
