import 'package:collection/collection.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

import '../data/repository/season_grand_prix/season_grand_prix_repository.dart';
import '../model/grand_prix.dart';
import '../model/season_grand_prix.dart';
import '../ui/service/date_service.dart';
import 'get_grand_prix_based_on_season_grand_prix_use_case.dart';

@injectable
class GetFinishedGrandPrixesFromCurrentSeasonUseCase {
  final SeasonGrandPrixRepository _seasonGrandPrixRepository;
  final GetGrandPrixBasedOnSeasonGrandPrixUseCase
      _getGrandPrixBasedOnSeasonGrandPrixUseCase;
  final DateService _dateService;

  const GetFinishedGrandPrixesFromCurrentSeasonUseCase(
    this._seasonGrandPrixRepository,
    this._getGrandPrixBasedOnSeasonGrandPrixUseCase,
    this._dateService,
  );

  Stream<List<GrandPrix>> call() {
    final DateTime now = _dateService.getNow();
    final int currentYear = now.year;
    return _seasonGrandPrixRepository
        .getAllSeasonGrandPrixesFromSeason(currentYear)
        .map(
          (List<SeasonGrandPrix> allSeasonGrandPrixes) => allSeasonGrandPrixes
              .where(
                (seasonGrandPrix) => seasonGrandPrix.startDate.isBefore(now),
              )
              .map(_getGrandPrixBasedOnSeasonGrandPrixUseCase.call),
        )
        .switchMap(
          (Iterable<Stream<GrandPrix?>> grandPrixStreams) =>
              grandPrixStreams.isNotEmpty
                  ? Rx.combineLatest(
                      grandPrixStreams,
                      (List<GrandPrix?> grandPrixes) => grandPrixes,
                    )
                  : Stream.value(<GrandPrix>[]),
        )
        .map((grandPrixes) => grandPrixes.whereNotNull().toList());
  }
}
