import '../../../model/season_grand_prix.dart';

abstract interface class SeasonGrandPrixRepository {
  Stream<List<SeasonGrandPrix>> getAllFromSeason(int season);

  Stream<SeasonGrandPrix?> getById({
    required int season,
    required String seasonGrandPrixId,
  });
}
