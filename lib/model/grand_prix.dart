import 'package:equatable/equatable.dart';

class GrandPrix extends Equatable {
  final String id;
  final String name;
  final DateTime startDate;
  final DateTime endDate;

  const GrandPrix({
    required this.id,
    required this.name,
    required this.startDate,
    required this.endDate,
  });

  @override
  List<Object?> get props => [id, name, startDate, endDate];
}
