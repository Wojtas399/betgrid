import 'package:freezed_annotation/freezed_annotation.dart';

part 'season_grand_prix_bet_state.freezed.dart';

@freezed
class SeasonGrandPrixBetState with _$SeasonGrandPrixBetState {
  const factory SeasonGrandPrixBetState.initial() = _Initial;
  const factory SeasonGrandPrixBetState.editor() = _Editor;
  const factory SeasonGrandPrixBetState.preview() = _Preview;
  const factory SeasonGrandPrixBetState.seasonGrandPrixNotFound() =
      _SeasonGrandPrixNotFound;
}
