import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../data/repository/grand_prix_basic_info/grand_prix_basic_info_repository.dart';
import '../../../../data/repository/season_grand_prix/season_grand_prix_repository.dart';
import '../../../../model/grand_prix_basic_info.dart';
import '../../../../model/season_grand_prix.dart';
import '../../../../model/season_grand_prix_details.dart';
import '../../../service/date_service.dart';
import 'season_grand_prixes_results_state.dart';

@injectable
class SeasonGrandPrixesResultsCubit
    extends Cubit<SeasonGrandPrixesResultsState> {
  final DateService _dateService;
  final SeasonGrandPrixRepository _seasonGrandPrixRepository;
  final GrandPrixBasicInfoRepository _grandPrixBasicInfoRepository;
  StreamSubscription<List<SeasonGrandPrixDetails>>? _listener;

  SeasonGrandPrixesResultsCubit(
    this._dateService,
    this._seasonGrandPrixRepository,
    this._grandPrixBasicInfoRepository,
  ) : super(const SeasonGrandPrixesResultsState.initial());

  @override
  Future<void> close() {
    _listener?.cancel();
    return super.close();
  }

  void initialize() {
    final int currentSeason = _dateService.getNow().year;

    _listener = _getDetailsOfSeasonGrandPrixes(currentSeason).listen((
      List<SeasonGrandPrixDetails> seasonGrandPrixes,
    ) {
      final List<SeasonGrandPrixDetails> sortedSeasonGrandPrixes = [
        ...seasonGrandPrixes,
      ]..sortByRoundNumber();

      emit(
        SeasonGrandPrixesResultsState.loaded(
          season: currentSeason,
          seasonGrandPrixes: sortedSeasonGrandPrixes,
        ),
      );
    });
  }

  Stream<List<SeasonGrandPrixDetails>> _getDetailsOfSeasonGrandPrixes(
    int currentSeason,
  ) {
    return _seasonGrandPrixRepository.getAllFromSeason(currentSeason).switchMap(
      (Iterable<SeasonGrandPrix> seasonGrandPrixes) {
        final List<Stream<SeasonGrandPrixDetails?>> streams =
            seasonGrandPrixes.map(_getDetailsForSeasonGrandPrix).toList();

        return Rx.combineLatest(
          streams,
          (data) => data.whereType<SeasonGrandPrixDetails>().toList(),
        );
      },
    );
  }

  Stream<SeasonGrandPrixDetails?> _getDetailsForSeasonGrandPrix(
    SeasonGrandPrix seasonGrandPrix,
  ) {
    return _grandPrixBasicInfoRepository
        .getById(seasonGrandPrix.grandPrixId)
        .map(
          (GrandPrixBasicInfo? grandPrixBasicInfo) =>
              grandPrixBasicInfo != null
                  ? SeasonGrandPrixDetails(
                    seasonGrandPrixId: seasonGrandPrix.id,
                    grandPrixId: grandPrixBasicInfo.id,
                    grandPrixName: grandPrixBasicInfo.name,
                    countryAlpha2Code: grandPrixBasicInfo.countryAlpha2Code,
                    roundNumber: seasonGrandPrix.roundNumber,
                    startDate: seasonGrandPrix.startDate,
                    endDate: seasonGrandPrix.endDate,
                  )
                  : null,
        );
  }
}

extension _SeasonGrandPrixDetailsListX on List<SeasonGrandPrixDetails> {
  void sortByRoundNumber() {
    sort((sgp1, sgp2) => sgp1.roundNumber.compareTo(sgp2.roundNumber));
  }
}
