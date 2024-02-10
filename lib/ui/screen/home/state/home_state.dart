import 'package:equatable/equatable.dart';

import '../../../../model/grand_prix.dart';

sealed class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

class HomeStateDataLoaded extends HomeState {
  final List<GrandPrix> grandPrixes;

  const HomeStateDataLoaded({required this.grandPrixes});

  @override
  List<Object?> get props => [grandPrixes];
}

class HomeStateLoggedUserNotFound extends HomeState {
  const HomeStateLoggedUserNotFound();
}
