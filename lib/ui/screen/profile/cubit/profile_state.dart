import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../model/user.dart';

part 'profile_state.freezed.dart';

enum ProfileStateStatus {
  loading,
  completed,
  usernameUpdated,
  loggedUserDoesNotExist,
  newUsernameIsEmpty,
  newUsernameIsAlreadyTaken,
}

@freezed
class ProfileState with _$ProfileState {
  const factory ProfileState({
    @Default(ProfileStateStatus.loading) ProfileStateStatus status,
    String? avatarUrl,
    String? username,
    ThemeMode? themeMode,
    ThemePrimaryColor? themePrimaryColor,
  }) = _ProfileState;
}
