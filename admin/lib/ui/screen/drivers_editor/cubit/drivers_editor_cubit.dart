import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../../data/repository/driver_personal_data/driver_personal_data_repository.dart';
import '../../../../model/driver_personal_data.dart';
import 'drivers_editor_state.dart';

@injectable
class DriversEditorCubit extends Cubit<DriversEditorState> {
  final DriverPersonalDataRepository _driverPersonalDataRepository;
  StreamSubscription<List<DriverPersonalData>>? _driversSubscription;

  DriversEditorCubit(this._driverPersonalDataRepository)
    : super(const DriversEditorState());

  @override
  Future<void> close() {
    _driversSubscription?.cancel();
    return super.close();
  }

  Future<void> initialize() async {
    _driversSubscription = _driverPersonalDataRepository.getAll().listen((
      List<DriverPersonalData> drivers,
    ) {
      final sortedDrivers = [...drivers];
      sortedDrivers.sortBySurname();
      emit(
        state.copyWith(
          status: DriversEditorStateStatus.completed,
          drivers: sortedDrivers,
        ),
      );
    });
  }

  Future<void> deleteDriverPersonalData(String id) async {
    assert(id.isNotEmpty);
    emit(state.copyWith(status: DriversEditorStateStatus.loading));
    await _driverPersonalDataRepository.deleteById(id);
    emit(state.copyWith(status: DriversEditorStateStatus.driverDeleted));
  }
}

extension DriversListX on List<DriverPersonalData> {
  void sortBySurname() {
    sort((d1, d2) => d1.surname.compareTo(d2.surname));
  }
}
