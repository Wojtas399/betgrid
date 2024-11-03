import 'entity.dart';

class Team extends Entity {
  final String name;
  final String hexColor;

  const Team({
    required super.id,
    required this.name,
    required this.hexColor,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        hexColor,
      ];
}
