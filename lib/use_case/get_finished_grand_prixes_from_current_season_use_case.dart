import 'package:injectable/injectable.dart';

import '../data/repository/season_grand_prix/season_grand_prix_repository.dart';
import '../model/season_grand_prix.dart';
import '../ui/service/date_service.dart';

@injectable
class GetFinishedGrandPrixesFromCurrentSeasonUseCase {
  final SeasonGrandPrixRepository _seasonGrandPrixRepository;
  final DateService _dateService;

  const GetFinishedGrandPrixesFromCurrentSeasonUseCase(
    this._seasonGrandPrixRepository,
    this._dateService,
  );

  Stream<List<SeasonGrandPrix>> call() {
    final DateTime now = _dateService.getNow();
    final int currentYear = now.year;
    return _seasonGrandPrixRepository
        .getAllSeasonGrandPrixesFromSeason(currentYear)
        .map(
          (List<SeasonGrandPrix> allSeasonGrandPrixes) => allSeasonGrandPrixes
              .where(
                (seasonGrandPrix) => seasonGrandPrix.startDate.isBefore(now),
              )
              .toList(),
        );
  }
}
