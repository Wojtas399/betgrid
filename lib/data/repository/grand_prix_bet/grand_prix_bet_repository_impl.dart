import '../../../dependency_injection.dart';
import '../../../firebase/model/grand_prix_bet/grand_prix_bet_dto.dart';
import '../../../firebase/service/firebase_grand_prix_bet_service.dart';
import '../../../model/grand_prix_bet.dart';
import '../../mapper/grand_prix_bet_mapper.dart';
import '../repository.dart';
import 'grand_prix_bet_repository.dart';

class GrandPrixBetRepositoryImpl extends Repository<GrandPrixBet>
    implements GrandPrixBetRepository {
  final FirebaseGrandPrixBetService _dbGrandPrixBetService;

  GrandPrixBetRepositoryImpl({super.initialData})
      : _dbGrandPrixBetService = getIt<FirebaseGrandPrixBetService>();

  @override
  Stream<List<GrandPrixBet>?> getAllGrandPrixBets({
    required String userId,
  }) async* {
    if (isRepositoryStateNotInitialized || isRepositoryStateEmpty) {
      await _loadAllGrandPrixBetsFromDb(userId);
    }
    await for (final grandPrixBets in repositoryState$) {
      yield grandPrixBets;
    }
  }

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

  Future<void> _loadAllGrandPrixBetsFromDb(String userId) async {
    final List<GrandPrixBetDto> grandPrixBetDtos =
        await _dbGrandPrixBetService.loadAllGrandPrixBets(userId: userId);
    final List<GrandPrixBet> grandPrixBets =
        grandPrixBetDtos.map(mapGrandPrixBetFromDto).toList();
    setEntities(grandPrixBets);
  }
}
