import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../../data/repository/driver_personal_data/driver_personal_data_repository.dart';
import 'new_driver_dialog_state.dart';

@injectable
class NewDriverDialogCubit extends Cubit<NewDriverDialogState> {
  final DriverPersonalDataRepository _driverPersonalDataRepository;

  NewDriverDialogCubit(this._driverPersonalDataRepository)
    : super(const NewDriverDialogState());

  void onNameChanged(String newName) {
    emit(
      state.copyWith(
        status: NewDriverDialogStateStatus.completed,
        name: newName,
      ),
    );
  }

  void onSurnameChanged(String newSurname) {
    emit(
      state.copyWith(
        status: NewDriverDialogStateStatus.completed,
        surname: newSurname,
      ),
    );
  }

  Future<void> submit() async {
    if (state.name.isEmpty || state.surname.isEmpty) {
      emit(state.copyWith(status: NewDriverDialogStateStatus.formNotCompleted));
      return;
    }
    emit(state.copyWith(status: NewDriverDialogStateStatus.loading));
    await _driverPersonalDataRepository.add(
      name: state.name,
      surname: state.surname,
    );
    emit(
      state.copyWith(
        status: NewDriverDialogStateStatus.newDriverPersonalDataAdded,
        name: '',
        surname: '',
      ),
    );
  }
}
