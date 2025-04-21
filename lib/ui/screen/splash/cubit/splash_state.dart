import 'package:freezed_annotation/freezed_annotation.dart';

part 'splash_state.freezed.dart';

@freezed
class SplashState with _$SplashState {
  const factory SplashState.initial() = SplashStateInitial;
  const factory SplashState.loading({required double progress}) =
      SplashStateLoading;
  const factory SplashState.appVersionChecked({
    required bool isNewVersionAvailable,
  }) = SplashStateAppVersionChecked;
  const factory SplashState.loaded({required bool isLoggedIn}) =
      SplashStateLoaded;
}
