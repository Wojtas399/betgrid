import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../model/user.dart';

part 'profile_state.freezed.dart';

enum ProfileStateStatus {
  loading,
  completed,
  usernameUpdated,
  newUsernameIsAlreadyTaken,
}

extension ProfileStateStatusExtensions on ProfileStateStatus {
  bool get isLoading => this == ProfileStateStatus.loading;

  bool get isUsernameUpdated => this == ProfileStateStatus.usernameUpdated;

  bool get isNewUsernameAlreadyTaken =>
      this == ProfileStateStatus.newUsernameIsAlreadyTaken;
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
