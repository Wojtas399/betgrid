import 'entity.dart';

class TeamBasicInfo extends Entity {
  final String name;
  final String hexColor;

  const TeamBasicInfo({
    required super.id,
    required this.name,
    required this.hexColor,
  });

  @override
  List<Object?> get props => [id, name, hexColor];
}
