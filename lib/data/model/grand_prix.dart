import 'package:equatable/equatable.dart';

class GrandPrix extends Equatable {
  final String id;
  final DateTime startDate;
  final DateTime endDate;
  final String name;

  const GrandPrix({
    required this.id,
    required this.startDate,
    required this.endDate,
    required this.name,
  });

  @override
  List<Object?> get props => [id, startDate, endDate, name];
}
