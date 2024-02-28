import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../model/grand_prix_results.dart';
import 'grand_prix_results_repository_impl.dart';

part 'grand_prix_results_repository.g.dart';

@riverpod
GrandPrixResultsRepository grandPrixResultsRepository(
  GrandPrixResultsRepositoryRef ref,
) =>
    GrandPrixResultsRepositoryImpl();

abstract interface class GrandPrixResultsRepository {
  Stream<GrandPrixResults?> getResultForGrandPrix({
    required String grandPrixId,
  });
}
