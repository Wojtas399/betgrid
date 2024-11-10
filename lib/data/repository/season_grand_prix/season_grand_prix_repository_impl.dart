import 'package:injectable/injectable.dart';

import '../../../model/season_grand_prix.dart';
import '../../firebase/service/firebase_season_grand_prix_service.dart';
import '../../mapper/season_grand_prix_mapper.dart';
import '../repository.dart';
import 'season_grand_prix_repository.dart';

@LazySingleton(as: SeasonGrandPrixRepository)
class SeasonGrandPrixRepositoryImpl extends Repository<SeasonGrandPrix>
    implements SeasonGrandPrixRepository {
  final FirebaseSeasonGrandPrixService _firebaseSeasonGrandPrixService;
  final SeasonGrandPrixMapper _seasonGrandPrixMapper;

  SeasonGrandPrixRepositoryImpl(
    this._firebaseSeasonGrandPrixService,
    this._seasonGrandPrixMapper,
  );

  @override
  Stream<List<SeasonGrandPrix>> getAllSeasonGrandPrixesFromSeason(
    int season,
  ) async* {
    await _fetchAllSeasonGrandPrixesFromSeason(season);
    await for (final allSeasonGrandPrixes in repositoryState$) {
      yield allSeasonGrandPrixes
          .where((seasonGrandPrix) => seasonGrandPrix.season == season)
          .toList();
    }
  }

  Future<void> _fetchAllSeasonGrandPrixesFromSeason(int season) async {
    final seasonGrandPrixDtos = await _firebaseSeasonGrandPrixService
        .fetchAllSeasonGrandPrixesFromSeason(season);
    if (seasonGrandPrixDtos.isNotEmpty) {
      final seasonGrandPrixes =
          seasonGrandPrixDtos.map(_seasonGrandPrixMapper.mapFromDto);
      addOrUpdateEntities(seasonGrandPrixes);
    }
  }
}
