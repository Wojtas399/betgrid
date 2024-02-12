import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../data/repository/grand_prix/grand_prix_repository.dart';
import '../../../riverpod_provider/grand_prix_id/grand_prix_id_provider.dart';

part 'qualifications_bet_grand_prix_name_provider.g.dart';

@Riverpod(dependencies: [grandPrixId])
Future<String?> qualificationsBetGrandPrixName(
  QualificationsBetGrandPrixNameRef ref,
) async {
  final String? grandPrixId = ref.watch(grandPrixIdProvider);
  if (grandPrixId == null) throw 'Grand prix id not found';
  final grandPrix = await ref
      .read(grandPrixRepositoryProvider)
      .loadGrandPrixById(grandPrixId: grandPrixId);
  return grandPrix?.name;
}
