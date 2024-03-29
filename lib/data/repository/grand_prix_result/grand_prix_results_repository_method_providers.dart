import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../model/grand_prix_results.dart';
import 'grand_prix_results_repository.dart';

part 'grand_prix_results_repository_method_providers.g.dart';

@riverpod
Stream<GrandPrixResults?> grandPrixResults(
  GrandPrixResultsRef ref, {
  required String grandPrixId,
}) =>
    ref
        .watch(grandPrixResultsRepositoryProvider)
        .getResultForGrandPrix(grandPrixId: grandPrixId);
