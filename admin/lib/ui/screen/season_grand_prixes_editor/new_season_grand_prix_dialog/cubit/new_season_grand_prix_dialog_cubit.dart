import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../../data/repository/grand_prix_basic_info/grand_prix_basic_info_repository.dart';
import '../../../../../data/repository/season_grand_prix/season_grand_prix_repository.dart';
import '../../../../../model/grand_prix_basic_info.dart';
import '../../../../../model/season_grand_prix.dart';
import 'new_season_grand_prix_dialog_state.dart';

@injectable
class NewSeasonGrandPrixDialogCubit
    extends Cubit<NewSeasonGrandPrixDialogState> {
  final SeasonGrandPrixRepository _seasonGrandPrixRepository;
  final GrandPrixBasicInfoRepository _grandPrixBasicInfoRepository;
  final int season;
  StreamSubscription<Iterable<GrandPrixBasicInfo>>? _listener;

  NewSeasonGrandPrixDialogCubit(
    this._seasonGrandPrixRepository,
    this._grandPrixBasicInfoRepository,
    @factoryParam this.season,
  ) : super(const NewSeasonGrandPrixDialogState());

  @override
  Future<void> close() {
    _listener?.cancel();
    return super.close();
  }

  void initialize() {
    _listener = _getGrandPrixesToSelect().listen((
      Iterable<GrandPrixBasicInfo> grandPrixes,
    ) {
      emit(
        state.copyWith(
          status: NewSeasonGrandPrixDialogStateStatus.completed,
          grandPrixesToSelect: grandPrixes,
        ),
      );
    });
  }

  void onGrandPrixSelected(String grandPrixId) {
    assert(grandPrixId.isNotEmpty);
    emit(
      state.copyWith(
        status: NewSeasonGrandPrixDialogStateStatus.completed,
        selectedGrandPrixId: grandPrixId,
      ),
    );
  }

  void onRoundNumberChanged(int roundNumber) {
    assert(roundNumber > 0);
    emit(
      state.copyWith(
        status: NewSeasonGrandPrixDialogStateStatus.completed,
        roundNumber: roundNumber,
      ),
    );
  }

  void onStartDateChanged(DateTime startDate) {
    assert(state.endDate == null || startDate.isBefore(state.endDate!));
    emit(
      state.copyWith(
        status: NewSeasonGrandPrixDialogStateStatus.completed,
        startDate: startDate,
      ),
    );
  }

  void onEndDateChanged(DateTime endDate) {
    assert(state.startDate == null || endDate.isAfter(state.startDate!));
    emit(
      state.copyWith(
        status: NewSeasonGrandPrixDialogStateStatus.completed,
        endDate: endDate,
      ),
    );
  }

  Future<void> submit() async {
    final String? selectedGrandPrixId = state.selectedGrandPrixId;
    final int? roundNumber = state.roundNumber;
    final DateTime? startDate = state.startDate;
    final DateTime? endDate = state.endDate;
    if (_isFormCompleted) {
      emit(
        state.copyWith(
          status: NewSeasonGrandPrixDialogStateStatus.savingGrandPrix,
        ),
      );
      await _seasonGrandPrixRepository.add(
        season: season,
        grandPrixId: selectedGrandPrixId!,
        roundNumber: roundNumber!,
        startDate: startDate!,
        endDate: endDate!,
      );
      emit(
        state.copyWith(
          status: NewSeasonGrandPrixDialogStateStatus.grandPrixSaved,
          selectedGrandPrixId: null,
          roundNumber: null,
          startDate: null,
          endDate: null,
        ),
      );
    } else {
      emit(
        state.copyWith(
          status: NewSeasonGrandPrixDialogStateStatus.formNotCompleted,
        ),
      );
    }
  }

  Stream<Iterable<GrandPrixBasicInfo>> _getGrandPrixesToSelect() {
    return Rx.combineLatest2(
      _seasonGrandPrixRepository.getAllFromSeason(season),
      _grandPrixBasicInfoRepository.getAll(),
      (
        Iterable<SeasonGrandPrix> seasonGrandPrixes,
        Iterable<GrandPrixBasicInfo> grandPrixes,
      ) {
        final idsOfGrandPrixesInSeason = seasonGrandPrixes.map(
          (seasonGrandPrix) => seasonGrandPrix.grandPrixId,
        );
        return grandPrixes.where(
          (grandPrix) => !idsOfGrandPrixesInSeason.contains(grandPrix.id),
        );
      },
    );
  }

  bool get _isFormCompleted =>
      state.isGrandPrixSelected &&
      state.isRoundNumberValid &&
      state.isStartDateValid &&
      state.isEndDateValid;
}
