import 'package:injectable/injectable.dart';

@injectable
class BetPointsMultipliersConfig {
  double get perfectQ1 => 1.25;
  double get perfectQ2 => 1.5;
  double get perfectQ3 => 1.75;
  double get perfectRacePodiumAndP10 => 1.5;
  double get perfectDnf => 1.5;
}
