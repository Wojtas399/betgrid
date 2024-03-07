import 'package:equatable/equatable.dart';

class PointsDetails extends Equatable {
  final double totalPoints;
  final int pointsBeforeMultiplication;
  final double? multiplier;

  const PointsDetails({
    required this.totalPoints,
    required this.pointsBeforeMultiplication,
    this.multiplier,
  });

  @override
  List<Object?> get props => [
        totalPoints,
        pointsBeforeMultiplication,
        multiplier,
      ];
}
