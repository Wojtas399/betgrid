import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../data/repository/grand_prix_result/grand_prix_results_repository.dart';
import '../../../../dependency_injection.dart';
import '../../../../model/grand_prix_results.dart';
import '../../../provider/grand_prix_id_provider.dart';

part 'results_for_grand_prix_provider.g.dart';

@Riverpod(dependencies: [grandPrixId])
Future<GrandPrixResults?> resultsForGrandPrix(
  ResultsForGrandPrixRef ref,
) async {
  final String? grandPrixId = ref.watch(grandPrixIdProvider);
  return grandPrixId != null
      ? await getIt
          .get<GrandPrixResultsRepository>()
          .getResultForGrandPrix(grandPrixId: grandPrixId)
          .first
      : null;
}
