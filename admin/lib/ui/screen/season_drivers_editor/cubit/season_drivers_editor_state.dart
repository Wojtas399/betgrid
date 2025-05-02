import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'season_drivers_editor_state.freezed.dart';

enum SeasonDriversEditorStateStatus {
  initial,
  completed,
  changingSeason,
  deletingDriverFromSeason,
  driverDeletedFromSeason,
}

extension SeasonDriversEditorStateStatusExtensions
    on SeasonDriversEditorStateStatus {
  bool get isInitial => this == SeasonDriversEditorStateStatus.initial;

  bool get isChangingSeason =>
      this == SeasonDriversEditorStateStatus.changingSeason;

  bool get isDeletingDriverFromSeason =>
      this == SeasonDriversEditorStateStatus.deletingDriverFromSeason;

  bool get hasDriverBeenDeletedFromSeason =>
      this == SeasonDriversEditorStateStatus.driverDeletedFromSeason;
}

@freezed
abstract class SeasonDriversEditorState with _$SeasonDriversEditorState {
  const factory SeasonDriversEditorState({
    @Default(SeasonDriversEditorStateStatus.initial)
    SeasonDriversEditorStateStatus status,
    int? currentSeason,
    int? selectedSeason,
    List<SeasonDriverDescription>? driversInSeason,
    bool? areThereOtherDriversToAdd,
  }) = _SeasonDriversEditorState;
}

class SeasonDriverDescription extends Equatable {
  final String seasonDriverId;
  final String driverId;
  final String name;
  final String surname;
  final int numberInSeason;
  final String teamNameInSeason;

  const SeasonDriverDescription({
    required this.seasonDriverId,
    required this.driverId,
    required this.name,
    required this.surname,
    required this.numberInSeason,
    required this.teamNameInSeason,
  });

  @override
  List<Object?> get props => [
    seasonDriverId,
    driverId,
    name,
    surname,
    numberInSeason,
    teamNameInSeason,
  ];
}
