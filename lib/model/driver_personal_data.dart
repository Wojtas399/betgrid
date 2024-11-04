import 'entity.dart';

class DriverPersonalData extends Entity {
  final String name;
  final String surname;

  const DriverPersonalData({
    required super.id,
    required this.name,
    required this.surname,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        surname,
      ];
}
