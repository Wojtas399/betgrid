import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../../data/repository/team_basic_info/team_basic_info_repository.dart';
import 'new_team_dialog_state.dart';

@injectable
class NewTeamDialogCubit extends Cubit<NewTeamDialogState> {
  final TeamBasicInfoRepository _teamBasicInfoRepository;

  NewTeamDialogCubit(this._teamBasicInfoRepository)
    : super(const NewTeamDialogState());

  void onNameChanged(String name) {
    emit(
      state.copyWith(status: NewTeamDialogStateStatus.completed, name: name),
    );
  }

  void onHexColorChanged(String hexColor) {
    emit(
      state.copyWith(
        status: NewTeamDialogStateStatus.completed,
        hexColor: hexColor,
      ),
    );
  }

  Future<void> submit() async {
    if (state.name.isEmpty || state.hexColor.isEmpty) {
      emit(state.copyWith(status: NewTeamDialogStateStatus.formNotCompleted));
      return;
    }
    emit(state.copyWith(status: NewTeamDialogStateStatus.loading));
    await _teamBasicInfoRepository.add(
      name: state.name,
      hexColor: state.hexColor,
    );
    emit(
      state.copyWith(
        status: NewTeamDialogStateStatus.teamBasicInfoAdded,
        name: '',
        hexColor: '',
      ),
    );
  }
}
