import '../../../model/season_grand_prix.dart';

abstract interface class SeasonGrandPrixRepository {
  Stream<Iterable<SeasonGrandPrix>> getAllFromSeason(int season);

  Stream<SeasonGrandPrix?> getById({required int season, required String id});

  Future<void> add({
    required int season,
    required String grandPrixId,
    required int roundNumber,
    required DateTime startDate,
    required DateTime endDate,
  });

  Future<void> delete({required int season, required String seasonGrandPrixId});
}
