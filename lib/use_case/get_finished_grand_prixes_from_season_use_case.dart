import 'package:injectable/injectable.dart';

import '../data/repository/season_grand_prix/season_grand_prix_repository.dart';
import '../model/season_grand_prix.dart';
import '../ui/service/date_service.dart';

@injectable
class GetFinishedGrandPrixesFromSeasonUseCase {
  final SeasonGrandPrixRepository _seasonGrandPrixRepository;
  final DateService _dateService;

  const GetFinishedGrandPrixesFromSeasonUseCase(
    this._seasonGrandPrixRepository,
    this._dateService,
  );

  Stream<List<SeasonGrandPrix>> call({
    required int season,
  }) {
    final DateTime now = _dateService.getNow();
    return _seasonGrandPrixRepository
        .getAllSeasonGrandPrixesFromSeason(season)
        .map(
          (List<SeasonGrandPrix> allSeasonGrandPrixes) => allSeasonGrandPrixes
              .where(
                (seasonGrandPrix) => seasonGrandPrix.startDate.isBefore(now),
              )
              .toList(),
        );
  }
}
