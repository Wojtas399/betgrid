import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../data/repository/auth/auth_repository.dart';
import '../../../../data/repository/grand_prix/grand_prix_repository.dart';
import '../../../../data/repository/grand_prix_bet/grand_prix_bet_repository.dart';
import '../../../../data/repository/user/user_repository.dart';
import '../../../../model/grand_prix.dart';
import '../../../../model/grand_prix_bet.dart';
import '../../../../model/user.dart';
import 'home_state.dart';

@injectable
class HomeCubit extends Cubit<HomeState> {
  final AuthRepository _authRepository;
  final UserRepository _userRepository;
  final GrandPrixBetRepository _grandPrixBetRepository;
  final GrandPrixRepository _grandPrixRepository;

  HomeCubit(
    this._authRepository,
    this._userRepository,
    this._grandPrixBetRepository,
    this._grandPrixRepository,
  ) : super(const HomeState());

  Future<void> initialize() async {
    final Stream<String?> loggedUserId$ = _authRepository.loggedUserId$;
    await for (final loggedUserId in loggedUserId$) {
      if (loggedUserId == null) {
        emit(state.copyWith(
          status: HomeStateStatus.loggedUserDoesNotExist,
        ));
      } else {
        await _initializeLoggedUser(loggedUserId);
      }
    }
  }

  Future<void> _initializeLoggedUser(String loggedUserId) async {
    final Stream<User?> loggedUser$ =
        _userRepository.getUserById(userId: loggedUserId);
    await for (final loggedUser in loggedUser$) {
      if (loggedUser == null) {
        emit(state.copyWith(
          status: HomeStateStatus.loggedUserDataNotCompleted,
        ));
      } else {
        if (await _doesLoggedUserNotHaveBets(loggedUser.id)) {
          await _initializeBets(loggedUser.id);
        }
        emit(state.copyWith(
          status: HomeStateStatus.completed,
          username: loggedUser.username,
          avatarUrl: loggedUser.avatarUrl,
        ));
      }
    }
  }

  Future<void> _initializeBets(String loggedUserId) async {
    final List<GrandPrix>? grandPrixes = await _grandPrixRepository
        .getAllGrandPrixesFromSeason(2024)
        .first; //TODO
    if (grandPrixes != null && grandPrixes.isNotEmpty) {
      await _grandPrixBetRepository.addGrandPrixBetsForPlayer(
        playerId: loggedUserId,
        grandPrixBets: _createBetsForGrandPrixes(
          grandPrixes,
          loggedUserId,
        ),
      );
    }
  }

  Future<bool> _doesLoggedUserNotHaveBets(String loggedUserId) async {
    final List<GrandPrixBet>? bets = await _grandPrixBetRepository
        .getAllGrandPrixBetsForPlayer(playerId: loggedUserId)
        .first;
    return bets == null || bets.isEmpty;
  }

  List<GrandPrixBet> _createBetsForGrandPrixes(
    List<GrandPrix> grandPrixes,
    String loggedUserId,
  ) {
    final List<String?> defaultQualiStandings = List.generate(20, (_) => null);
    final List<String?> defaultDnfDrivers = List.generate(3, (_) => null);
    return grandPrixes
        .map(
          (GrandPrix gp) => GrandPrixBet(
            id: '',
            playerId: loggedUserId,
            grandPrixId: gp.id,
            qualiStandingsByDriverIds: defaultQualiStandings,
            dnfDriverIds: defaultDnfDrivers,
          ),
        )
        .toList();
  }
}
