import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../model/team_basic_info.dart';

part 'teams_editor_state.freezed.dart';

enum TeamsEditorStateStatus { initial, completed, loading, teamDeleted }

extension TeamsEditorStateStatusExtensions on TeamsEditorStateStatus {
  bool get isInitial => this == TeamsEditorStateStatus.initial;

  bool get isLoading => this == TeamsEditorStateStatus.loading;

  bool get isTeamDeleted => this == TeamsEditorStateStatus.teamDeleted;
}

@freezed
abstract class TeamsEditorState with _$TeamsEditorState {
  const factory TeamsEditorState({
    @Default(TeamsEditorStateStatus.initial) TeamsEditorStateStatus status,
    List<TeamBasicInfo>? teams,
  }) = _TeamsEditorState;
}
