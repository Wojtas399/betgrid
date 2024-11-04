import 'package:betgrid/data/firebase/model/driver_personal_data_dto.dart';
import 'package:betgrid/model/driver_personal_data.dart';

class DriverPersonalDataCreator {
  final String id;
  final String name;
  final String surname;

  const DriverPersonalDataCreator({
    this.id = '',
    this.name = '',
    this.surname = '',
  });

  DriverPersonalData createEntity() {
    return DriverPersonalData(
      id: id,
      name: name,
      surname: surname,
    );
  }

  DriverPersonalDataDto createDto() {
    return DriverPersonalDataDto(
      id: id,
      name: name,
      surname: surname,
    );
  }

  Map<String, Object?> createJson() {
    return {
      'name': name,
      'surname': surname,
    };
  }
}
