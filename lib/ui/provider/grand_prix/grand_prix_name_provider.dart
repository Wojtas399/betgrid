import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/repository/grand_prix/grand_prix_repository.dart';
import '../../../model/grand_prix.dart';
import 'grand_prix_id_provider.dart';

part 'grand_prix_name_provider.g.dart';

@Riverpod(dependencies: [grandPrixId])
Stream<String?> grandPrixName(GrandPrixNameRef ref) {
  final String? grandPrixId = ref.watch(grandPrixIdProvider);
  return grandPrixId == null
      ? Stream.value(null)
      : ref
          .watch(grandPrixRepositoryProvider)
          .getGrandPrixById(grandPrixId: grandPrixId)
          .map((GrandPrix? grandPrix) => grandPrix?.name);
}
