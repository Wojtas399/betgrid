import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../model/grand_prix_basic_info.dart';

part 'grand_prixes_editor_state.freezed.dart';

enum GrandPrixesEditorStateStatus {
  initial,
  completed,
  loading,
  grandPrixDeleted,
}

extension GrandPrixesEditorStateStatusExtensions
    on GrandPrixesEditorStateStatus {
  bool get isInitial => this == GrandPrixesEditorStateStatus.initial;

  bool get isLoading => this == GrandPrixesEditorStateStatus.loading;

  bool get hasGrandPrixBeenDeleted =>
      this == GrandPrixesEditorStateStatus.grandPrixDeleted;
}

@freezed
abstract class GrandPrixesEditorState with _$GrandPrixesEditorState {
  const factory GrandPrixesEditorState({
    @Default(GrandPrixesEditorStateStatus.initial)
    GrandPrixesEditorStateStatus status,
    Iterable<GrandPrixBasicInfo>? grandPrixes,
  }) = _GrandPrixesEditorState;
}
