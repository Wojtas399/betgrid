import '../../../model/season_grand_prix.dart';

abstract interface class SeasonGrandPrixRepository {
  Stream<List<SeasonGrandPrix>> getAllSeasonGrandPrixesFromSeason(int season);

  Stream<SeasonGrandPrix?> getSeasonGrandPrixById(String id);
}
