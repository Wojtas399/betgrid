import 'package:equatable/equatable.dart';

import '../../../../model/driver_details.dart';

class PointsForDriver extends Equatable {
  final DriverDetails driverDetails;
  final double points;

  const PointsForDriver({required this.driverDetails, required this.points});

  @override
  List<Object?> get props => [driverDetails, points];
}
