import '../../../model/season_driver.dart';

abstract interface class SeasonDriverRepository {
  Stream<List<SeasonDriver>> getAllFromSeason(int season);

  Future<void> add({
    required int season,
    required String driverId,
    required int driverNumber,
    required String seasonTeamId,
  });

  Future<void> delete({required int season, required String seasonDriverId});
}
