import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../data/repository/grand_prix_result/grand_prix_results_repository_method_providers.dart';
import '../../../../model/grand_prix_results.dart';
import '../../../provider/grand_prix_id_provider.dart';

part 'grand_prix_results_provider.g.dart';

@Riverpod(dependencies: [grandPrixId])
Future<GrandPrixResults?> grandPrixResults(GrandPrixResultsRef ref) async {
  final String? grandPrixId = ref.watch(grandPrixIdProvider);
  return grandPrixId != null
      ? await ref.watch(
          resultsForGrandPrixProvider(
            grandPrixId: grandPrixId,
          ).future,
        )
      : null;
}
