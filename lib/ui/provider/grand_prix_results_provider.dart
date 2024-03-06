import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/repository/grand_prix_result/grand_prix_results_repository.dart';
import '../../model/grand_prix_results.dart';
import 'grand_prix/grand_prix_id_provider.dart';

part 'grand_prix_results_provider.g.dart';

@Riverpod(dependencies: [grandPrixId])
Stream<GrandPrixResults?> grandPrixResults(GrandPrixResultsRef ref) {
  final String? grandPrixId = ref.watch(grandPrixIdProvider);
  return grandPrixId != null
      ? ref.watch(grandPrixResultsRepositoryProvider).getResultForGrandPrix(
            grandPrixId: grandPrixId,
          )
      : Stream.value(null);
}
