import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../model/season_grand_prix_details.dart';

part 'season_grand_prixes_results_state.freezed.dart';

@freezed
sealed class SeasonGrandPrixesResultsState
    with _$SeasonGrandPrixesResultsState {
  const factory SeasonGrandPrixesResultsState.initial() =
      SeasonGrandPrixesResultsStateInitial;
  const factory SeasonGrandPrixesResultsState.loaded({
    required int season,
    required List<SeasonGrandPrixDetails> seasonGrandPrixes,
  }) = SeasonGrandPrixesResultsStateLoaded;
}
