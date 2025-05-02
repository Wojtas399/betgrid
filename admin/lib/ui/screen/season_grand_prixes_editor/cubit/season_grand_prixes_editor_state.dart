import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../model/season_grand_prix_details.dart';

part 'season_grand_prixes_editor_state.freezed.dart';

enum SeasonGrandPrixesEditorStateStatus {
  initial,
  completed,
  changingSeason,
  deletingGrandPrixFromSeason,
  grandPrixDeletedFromSeason,
}

extension SeasonGrandPrixesEditorStateStatusX
    on SeasonGrandPrixesEditorStateStatus {
  bool get isInitial => this == SeasonGrandPrixesEditorStateStatus.initial;

  bool get isChangingSeason =>
      this == SeasonGrandPrixesEditorStateStatus.changingSeason;

  bool get isDeletingGrandPrixFromSeason =>
      this == SeasonGrandPrixesEditorStateStatus.deletingGrandPrixFromSeason;

  bool get hasGrandPrixBeenDeletedFromSeason =>
      this == SeasonGrandPrixesEditorStateStatus.grandPrixDeletedFromSeason;
}

@freezed
abstract class SeasonGrandPrixesEditorState
    with _$SeasonGrandPrixesEditorState {
  const factory SeasonGrandPrixesEditorState({
    @Default(SeasonGrandPrixesEditorStateStatus.initial)
    SeasonGrandPrixesEditorStateStatus status,
    int? currentSeason,
    int? selectedSeason,
    List<SeasonGrandPrixDetails>? grandPrixesInSeason,
    bool? areThereOtherGrandPrixesToAdd,
  }) = _SeasonGrandPrixesEditorState;
}
