import 'package:injectable/injectable.dart';

@injectable
class BetPointsMultipliersConfig {
  double get perfectQ1Multiplier => 1.25;
  double get perfectQ2Multiplier => 1.5;
  double get perfectQ3Multiplier => 1.75;
  double get perfectRacePodiumAndP10 => 1.5;
}
