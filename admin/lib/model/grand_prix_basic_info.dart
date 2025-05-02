import 'entity.dart';

class GrandPrixBasicInfo extends Entity {
  final String name;
  final String countryAlpha2Code;

  const GrandPrixBasicInfo({
    required super.id,
    required this.name,
    required this.countryAlpha2Code,
  });

  @override
  List<Object?> get props => [id, name, countryAlpha2Code];

  get countryCode => null;
}
