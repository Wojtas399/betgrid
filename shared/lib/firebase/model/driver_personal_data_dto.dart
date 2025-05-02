class DriverPersonalDataDto {
  final String id;
  final String name;
  final String surname;

  DriverPersonalDataDto({
    this.id = '',
    required this.name,
    required this.surname,
  });

  factory DriverPersonalDataDto.fromFirestore({
    required String id,
    required Map<String, dynamic> json,
  }) {
    return DriverPersonalDataDto(
      id: id,
      name: json[DriverPersonalDataFields.name],
      surname: json[DriverPersonalDataFields.surname],
    );
  }

  Map<String, dynamic> toFirestore() => {
        DriverPersonalDataFields.name: name,
        DriverPersonalDataFields.surname: surname,
      };
}

class DriverPersonalDataFields {
  static const name = 'name';
  static const surname = 'surname';
}
