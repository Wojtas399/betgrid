import 'package:equatable/equatable.dart';

import '../../../../model/driver.dart';

abstract class QualificationsBetState extends Equatable {
  const QualificationsBetState();

  @override
  List<Object?> get props => [];
}

class QualificationsBetStateDataLoaded extends QualificationsBetState {
  final List<Driver> drivers;

  const QualificationsBetStateDataLoaded({required this.drivers});

  @override
  List<Object?> get props => [drivers];
}
