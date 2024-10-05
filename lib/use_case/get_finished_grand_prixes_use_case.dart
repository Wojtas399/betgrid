import 'package:injectable/injectable.dart';

import '../data/repository/grand_prix/grand_prix_repository.dart';
import '../model/grand_prix.dart';
import '../ui/service/date_service.dart';

@injectable
class GetFinishedGrandPrixesUseCase {
  final GrandPrixRepository _grandPrixRepository;
  final DateService _dateService;

  const GetFinishedGrandPrixesUseCase(
    this._grandPrixRepository,
    this._dateService,
  );

  Stream<List<GrandPrix>> call() =>
      //TODO
      _grandPrixRepository.getAllGrandPrixesFromSeason(2024).map(
        (List<GrandPrix>? allGrandPrixes) {
          if (allGrandPrixes == null || allGrandPrixes.isEmpty) return [];
          final now = _dateService.getNow();
          return allGrandPrixes
              .where((GrandPrix gp) => gp.startDate.isBefore(now))
              .toList();
        },
      );
}
