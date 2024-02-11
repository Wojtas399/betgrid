import 'package:equatable/equatable.dart';

import '../../../../model/driver.dart';

abstract class QualificationsBetState extends Equatable {
  const QualificationsBetState();

  @override
  List<Object?> get props => [];
}

class QualificationsBetStateDataLoaded extends QualificationsBetState {
  final String? gpName;
  final List<Driver>? drivers;
  final List<String>? qualiStandingsByDriverIds;

  const QualificationsBetStateDataLoaded({
    required this.gpName,
    required this.drivers,
    required this.qualiStandingsByDriverIds,
  });

  @override
  List<Object?> get props => [gpName, drivers, qualiStandingsByDriverIds];
}

class QualificationsBetStateLoggedUserNotFound extends QualificationsBetState {
  const QualificationsBetStateLoggedUserNotFound();
}
