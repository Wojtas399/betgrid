import 'entity.dart';

class GrandPrix extends Entity {
  final String name;
  final DateTime startDate;
  final DateTime endDate;

  const GrandPrix({
    required super.id,
    required this.name,
    required this.startDate,
    required this.endDate,
  });

  @override
  List<Object?> get props => [id, name, startDate, endDate];
}
