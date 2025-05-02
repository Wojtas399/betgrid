import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../../data/repository/grand_prix_basic_info/grand_prix_basic_info_repository.dart';
import '../../../../model/grand_prix_basic_info.dart';
import 'grand_prixes_editor_state.dart';

@injectable
class GrandPrixesEditorCubit extends Cubit<GrandPrixesEditorState> {
  final GrandPrixBasicInfoRepository _grandPrixBasicInfoRepository;
  StreamSubscription<Iterable<GrandPrixBasicInfo>>? _grandPrixesSubscription;

  GrandPrixesEditorCubit(this._grandPrixBasicInfoRepository)
    : super(const GrandPrixesEditorState());

  @override
  Future<void> close() {
    _grandPrixesSubscription?.cancel();
    return super.close();
  }

  void initialize() {
    _grandPrixesSubscription = _grandPrixBasicInfoRepository.getAll().listen((
      Iterable<GrandPrixBasicInfo> grandPrixes,
    ) {
      emit(
        state.copyWith(
          status: GrandPrixesEditorStateStatus.completed,
          grandPrixes: grandPrixes,
        ),
      );
    });
  }

  Future<void> deleteGrandPrix(String grandPrixId) async {
    assert(grandPrixId.isNotEmpty);
    emit(state.copyWith(status: GrandPrixesEditorStateStatus.loading));
    await _grandPrixBasicInfoRepository.deleteById(grandPrixId);
    emit(state.copyWith(status: GrandPrixesEditorStateStatus.grandPrixDeleted));
  }
}
