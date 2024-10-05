import 'package:injectable/injectable.dart';

import '../data/repository/grand_prix/grand_prix_repository.dart';
import '../model/grand_prix.dart';
import '../ui/service/date_service.dart';

@injectable
class GetFinishedGrandPrixesFromCurrentSeasonUseCase {
  final GrandPrixRepository _grandPrixRepository;
  final DateService _dateService;

  const GetFinishedGrandPrixesFromCurrentSeasonUseCase(
    this._grandPrixRepository,
    this._dateService,
  );

  Stream<List<GrandPrix>> call() {
    final DateTime now = _dateService.getNow();
    final int currentYear = now.year;
    return _grandPrixRepository.getAllGrandPrixesFromSeason(currentYear).map(
          (List<GrandPrix>? allGrandPrixes) =>
              allGrandPrixes?.isNotEmpty == true
                  ? allGrandPrixes!
                      .where((GrandPrix gp) => gp.startDate.isBefore(now))
                      .toList()
                  : [],
        );
  }
}
