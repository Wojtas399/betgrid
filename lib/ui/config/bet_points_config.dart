import 'package:injectable/injectable.dart';

@singleton
class BetPointsConfig {
  int get onePositionInQ1 => 1;
  int get onePositionInQ2 => 2;
  int get onePositionFromP10ToP4InQ3 => 2;
  int get onePositionFromP3ToP1InQ3 => 1;
  int get raceP1 => 2;
  int get raceP2 => 2;
  int get raceP3 => 2;
  int get raceP10 => 4;
  int get raceFastestLap => 2;
  int get raceOneDnfDriver => 1;
  int get raceSafetyCar => 1;
  int get raceRedFlag => 1;
}
