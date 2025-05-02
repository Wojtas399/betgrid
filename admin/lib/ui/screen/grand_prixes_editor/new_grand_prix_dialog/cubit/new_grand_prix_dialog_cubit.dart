import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../../data/repository/grand_prix_basic_info/grand_prix_basic_info_repository.dart';
import 'new_grand_prix_dialog_state.dart';

@injectable
class NewGrandPrixDialogCubit extends Cubit<NewGrandPrixDialogState> {
  final GrandPrixBasicInfoRepository _grandPrixBasicInfoRepository;

  NewGrandPrixDialogCubit(this._grandPrixBasicInfoRepository)
    : super(const NewGrandPrixDialogState());

  void onGrandPrixNameChanged(String grandPrixName) {
    emit(
      state.copyWith(
        status: NewGrandPrixDialogStateStatus.completed,
        grandPrixName: grandPrixName,
      ),
    );
  }

  void onCountryAlpha2CodeChanged(String countryAlpha2Code) {
    emit(
      state.copyWith(
        status: NewGrandPrixDialogStateStatus.completed,
        countryAlpha2Code: countryAlpha2Code,
      ),
    );
  }

  Future<void> addNewGrandPrix() async {
    if (state.isGrandPrixNameEmpty || state.isCountryAlpha2CodeEmpty) {
      emit(
        state.copyWith(status: NewGrandPrixDialogStateStatus.formNotCompleted),
      );
      return;
    }
    emit(state.copyWith(status: NewGrandPrixDialogStateStatus.loading));
    await _grandPrixBasicInfoRepository.add(
      name: state.grandPrixName,
      countryAlpha2Code: state.countryAlpha2Code,
    );
    emit(
      state.copyWith(
        status: NewGrandPrixDialogStateStatus.newGrandPrixAdded,
        grandPrixName: '',
        countryAlpha2Code: '',
      ),
    );
  }
}
