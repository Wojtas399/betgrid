import 'package:equatable/equatable.dart';

class Entity extends Equatable {
  final String id;

  const Entity({required this.id});

  @override
  List<Object?> get props => [id];
}
