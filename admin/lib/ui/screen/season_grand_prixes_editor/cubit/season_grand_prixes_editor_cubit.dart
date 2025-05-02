import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';
import '../../../../data/repository/grand_prix_basic_info/grand_prix_basic_info_repository.dart';
import '../../../../data/repository/season_grand_prix/season_grand_prix_repository.dart';
import '../../../../model/grand_prix_basic_info.dart';
import '../../../../model/season_grand_prix_details.dart';
import '../../../service/date_service.dart';
import 'season_grand_prixes_editor_state.dart';

@injectable
class SeasonGrandPrixesEditorCubit extends Cubit<SeasonGrandPrixesEditorState> {
  final SeasonGrandPrixRepository _seasonGrandPrixRepository;
  final GrandPrixBasicInfoRepository _grandPrixBasicInfoRepository;
  final DateService _dateService;
  StreamSubscription<_ListenedParams?>? _listener;

  SeasonGrandPrixesEditorCubit(
    this._seasonGrandPrixRepository,
    this._grandPrixBasicInfoRepository,
    this._dateService,
  ) : super(const SeasonGrandPrixesEditorState());

  @override
  Future<void> close() {
    _listener?.cancel();
    return super.close();
  }

  void initializeSeason() {
    assert(state.currentSeason == null && state.selectedSeason == null);
    final int currentSeason = _dateService.getNow().year;
    emit(
      state.copyWith(
        currentSeason: currentSeason,
        selectedSeason: currentSeason,
      ),
    );
  }

  void initializeGrandPrixes() {
    assert(state.currentSeason != null && state.selectedSeason != null);
    _listener = _getListenedParams(state.selectedSeason!).listen((
      _ListenedParams? params,
    ) {
      final sortedGrandPrixesInSeason = [
        ...?params?.descriptionsOfAllGrandPrixesFromSeason,
      ];
      sortedGrandPrixesInSeason.sortByRoundNumber();
      emit(
        state.copyWith(
          status: SeasonGrandPrixesEditorStateStatus.completed,
          grandPrixesInSeason: sortedGrandPrixesInSeason,
          areThereOtherGrandPrixesToAdd:
              params != null
                  ? _areThereOtherGrandPrixesNotAddedToSeason(params)
                  : false,
        ),
      );
    });
  }

  void onSeasonSelected(int season) {
    final int? currentSeason = state.currentSeason;
    assert(currentSeason != null);
    assert(season == currentSeason || season == currentSeason! + 1);
    emit(
      state.copyWith(status: SeasonGrandPrixesEditorStateStatus.changingSeason),
    );
    _listener?.cancel();
    _listener = _getListenedParams(season).listen((_ListenedParams? params) {
      final sortedGrandPrixesInSeason = [
        ...?params?.descriptionsOfAllGrandPrixesFromSeason,
      ];
      sortedGrandPrixesInSeason.sortByRoundNumber();
      emit(
        state.copyWith(
          status: SeasonGrandPrixesEditorStateStatus.completed,
          grandPrixesInSeason: sortedGrandPrixesInSeason,
          selectedSeason: season,
          areThereOtherGrandPrixesToAdd:
              params != null
                  ? _areThereOtherGrandPrixesNotAddedToSeason(params)
                  : false,
        ),
      );
    });
  }

  Future<void> deleteGrandPrixFromSeason({
    required String seasonGrandPrixId,
  }) async {
    assert(seasonGrandPrixId.isNotEmpty && state.selectedSeason != null);
    emit(
      state.copyWith(
        status: SeasonGrandPrixesEditorStateStatus.deletingGrandPrixFromSeason,
      ),
    );
    await _seasonGrandPrixRepository.delete(
      season: state.selectedSeason!,
      seasonGrandPrixId: seasonGrandPrixId,
    );
    emit(
      state.copyWith(
        status: SeasonGrandPrixesEditorStateStatus.grandPrixDeletedFromSeason,
      ),
    );
  }

  Stream<_ListenedParams?> _getListenedParams(int season) {
    return _grandPrixBasicInfoRepository.getAll().switchMap(
      (allGrandPrixesBasicInfo) =>
          allGrandPrixesBasicInfo.isNotEmpty
              ? Rx.combineLatest2(
                Stream.value(allGrandPrixesBasicInfo),
                _getDescriptionsOfGrandPrixesFromSeason(
                  season,
                  allGrandPrixesBasicInfo,
                ),
                (
                  Iterable<GrandPrixBasicInfo> allGrandPrixesBasicInfo,
                  List<SeasonGrandPrixDetails>
                  descriptionsOfAllGrandPrixesFromSeason,
                ) => (
                  descriptionsOfAllGrandPrixesFromSeason:
                      descriptionsOfAllGrandPrixesFromSeason,
                  allGrandPrixesBasicInfo: allGrandPrixesBasicInfo,
                ),
              )
              : Stream.value(null),
    );
  }

  bool _areThereOtherGrandPrixesNotAddedToSeason(_ListenedParams params) {
    final idsOfGrandPrixesInSeason = params
        .descriptionsOfAllGrandPrixesFromSeason
        .map((grandPrix) => grandPrix.grandPrixId);
    return params.allGrandPrixesBasicInfo
        .where((grandPrix) => !idsOfGrandPrixesInSeason.contains(grandPrix.id))
        .isNotEmpty;
  }

  Stream<List<SeasonGrandPrixDetails>> _getDescriptionsOfGrandPrixesFromSeason(
    int season,
    Iterable<GrandPrixBasicInfo> allGrandPrixesBasicInfo,
  ) {
    return _seasonGrandPrixRepository
        .getAllFromSeason(season)
        .map(
          (allGrandPrixesFromSeason) =>
              allGrandPrixesFromSeason.map((seasonGrandPrix) {
                final basicInfo = allGrandPrixesBasicInfo.firstWhere(
                  (gp) => gp.id == seasonGrandPrix.grandPrixId,
                );

                return SeasonGrandPrixDetails(
                  seasonGrandPrixId: seasonGrandPrix.id,
                  grandPrixId: seasonGrandPrix.grandPrixId,
                  grandPrixName: basicInfo.name,
                  countryAlpha2Code: basicInfo.countryAlpha2Code,
                  roundNumber: seasonGrandPrix.roundNumber,
                  startDate: seasonGrandPrix.startDate,
                  endDate: seasonGrandPrix.endDate,
                );
              }).toList(),
        );
  }
}

typedef _ListenedParams =
    ({
      List<SeasonGrandPrixDetails> descriptionsOfAllGrandPrixesFromSeason,
      Iterable<GrandPrixBasicInfo> allGrandPrixesBasicInfo,
    });

extension _ListOfGrandPrixDescriptionsX on List<SeasonGrandPrixDetails> {
  void sortByRoundNumber() {
    sort((gp1, gp2) => gp1.roundNumber.compareTo(gp2.roundNumber));
  }
}
