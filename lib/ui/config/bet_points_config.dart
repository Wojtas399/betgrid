import 'package:injectable/injectable.dart';

@injectable
class BetPointsConfig {
  int get correctBetInQ1 => 1;
  int get correctBetInQ2 => 2;
  int get correctBetFromP10ToP4InQ3 => 2;
  int get correctBetFromP3ToP1InQ3 => 1;
}
