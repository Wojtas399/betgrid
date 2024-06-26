import 'package:freezed_annotation/freezed_annotation.dart';

part 'home_state.freezed.dart';

enum HomeStateStatus {
  loading,
  completed,
  loggedUserDoesNotExist,
  loggedUserDataNotCompleted,
}

@freezed
class HomeState with _$HomeState {
  const factory HomeState({
    @Default(HomeStateStatus.loading) HomeStateStatus status,
    String? username,
    String? avatarUrl,
  }) = _HomeState;
}
