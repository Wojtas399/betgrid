class GrandPrixBasicInfoDto {
  final String id;
  final String name;
  final String countryAlpha2Code;

  const GrandPrixBasicInfoDto({
    this.id = '',
    required this.name,
    required this.countryAlpha2Code,
  });

  factory GrandPrixBasicInfoDto.fromFirestore({
    required String id,
    required Map<String, dynamic> json,
  }) {
    return GrandPrixBasicInfoDto(
      id: id,
      name: json[GrandPrixBasicInfoFields.name],
      countryAlpha2Code: json[GrandPrixBasicInfoFields.countryAlpha2Code],
    );
  }

  Map<String, dynamic> toFirestore() => {
        GrandPrixBasicInfoFields.name: name,
        GrandPrixBasicInfoFields.countryAlpha2Code: countryAlpha2Code,
      };
}

class GrandPrixBasicInfoFields {
  static const name = 'name';
  static const countryAlpha2Code = 'countryAlpha2Code';
}
