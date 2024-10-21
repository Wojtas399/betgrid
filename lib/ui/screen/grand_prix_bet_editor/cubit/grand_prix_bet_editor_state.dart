import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../model/driver.dart';

part 'grand_prix_bet_editor_state.freezed.dart';

enum GrandPrixBetEditorStateStatus {
  loading,
  completed,
}

@freezed
class GrandPrixBetEditorState with _$GrandPrixBetEditorState {
  const factory GrandPrixBetEditorState({
    @Default(GrandPrixBetEditorStateStatus.loading)
    GrandPrixBetEditorStateStatus status,
    List<Driver>? allDrivers,
  }) = _GrandPrixBetEditorState;
}
