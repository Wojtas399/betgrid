import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../data/repository/driver/driver_repository.dart';
import '../../../../model/driver.dart';
import 'grand_prix_bet_editor_state.dart';

@injectable
class GrandPrixBetEditorCubit extends Cubit<GrandPrixBetEditorState> {
  final DriverRepository _driverRepository;

  GrandPrixBetEditorCubit(
    this._driverRepository,
  ) : super(const GrandPrixBetEditorState());

  Future<void> initialize() async {
    final List<Driver> allDrivers =
        await _driverRepository.getAllDrivers().first;
    emit(state.copyWith(
      status: GrandPrixBetEditorStateStatus.completed,
      allDrivers: allDrivers,
    ));
  }
}
