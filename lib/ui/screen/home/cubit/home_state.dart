import 'package:freezed_annotation/freezed_annotation.dart';

part 'home_state.freezed.dart';

enum HomePage { bets, stats, players, teamsDetails }

enum HomeActionStatus { userDataNotCompleted, userSignedOut }

@freezed
sealed class HomeState with _$HomeState {
  const HomeState._();

  const factory HomeState.initial() = HomeStateInitial;

  const factory HomeState.loaded({
    HomeActionStatus? actionStatus,
    String? username,
    String? avatarUrl,
    double? totalPoints,
    @Default(HomePage.bets) HomePage selectedPage,
    required String appVersion,
  }) = HomeStateLoaded;

  HomeStateLoaded get loaded => this as HomeStateLoaded;
}
