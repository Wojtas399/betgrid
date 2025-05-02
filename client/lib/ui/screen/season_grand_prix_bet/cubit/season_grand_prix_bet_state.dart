import 'package:freezed_annotation/freezed_annotation.dart';

part 'season_grand_prix_bet_state.freezed.dart';

@freezed
class SeasonGrandPrixBetState with _$SeasonGrandPrixBetState {
  const factory SeasonGrandPrixBetState.initial() = _Initial;
  const factory SeasonGrandPrixBetState.editor({
    required int season,
    required String seasonGrandPrixId,
    required int roundNumber,
    required String grandPrixName,
    required Duration durationToStart,
    @Default(false) bool isSaving,
  }) = SeasonGrandPrixBetStateEditor;
  const factory SeasonGrandPrixBetState.preview({
    required int season,
    required String seasonGrandPrixId,
    required String grandPrixName,
    required String playerId,
    String? playerUsername,
  }) = SeasonGrandPrixBetStatePreview;
  const factory SeasonGrandPrixBetState.seasonGrandPrixNotFound() =
      _SeasonGrandPrixNotFound;
}
