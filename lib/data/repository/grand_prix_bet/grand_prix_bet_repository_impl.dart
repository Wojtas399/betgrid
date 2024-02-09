import '../../../dependency_injection.dart';
import '../../../firebase/service/firebase_grand_prix_bet_service.dart';
import '../../../model/grand_prix_bet.dart';
import '../../mapper/grand_prix_bet_mapper.dart';
import 'grand_prix_bet_repository.dart';

class GrandPrixBetRepositoryImpl implements GrandPrixBetRepository {
  final FirebaseGrandPrixBetService _dbGrandPrixBetService;

  GrandPrixBetRepositoryImpl()
      : _dbGrandPrixBetService = getIt<FirebaseGrandPrixBetService>();

  @override
  Future<void> addGrandPrixBets({
    required String userId,
    required List<GrandPrixBet> grandPrixBets,
  }) async {
    for (final grandPrixBet in grandPrixBets) {
      await _dbGrandPrixBetService.addGrandPrixBet(
        userId: userId,
        grandPrixBetDto: mapGrandPrixBetToDto(grandPrixBet),
      );
    }
  }
}
