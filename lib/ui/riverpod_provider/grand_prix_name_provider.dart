import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/repository/grand_prix/grand_prix_repository.dart';
import 'grand_prix_id_provider.dart';

part 'grand_prix_name_provider.g.dart';

@Riverpod(dependencies: [grandPrixId])
Future<String?> grandPrixName(GrandPrixNameRef ref) async {
  final String? grandPrixId = ref.watch(grandPrixIdProvider);
  if (grandPrixId == null) throw 'Grand prix id not found';
  final grandPrix = await ref
      .read(grandPrixRepositoryProvider)
      .loadGrandPrixById(grandPrixId: grandPrixId);
  return grandPrix?.name;
}
