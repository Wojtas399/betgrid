import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../firebase/service/firebase_grand_prix_results_service.dart';
import '../../../model/grand_prix_results.dart';
import 'grand_prix_results_repository_impl.dart';

part 'grand_prix_results_repository.g.dart';

abstract interface class GrandPrixResultsRepository {
  Stream<GrandPrixResults?> getResultForGrandPrix({
    required String grandPrixId,
  });
}

@Riverpod(keepAlive: true)
GrandPrixResultsRepository grandPrixResultsRepository(
  GrandPrixResultsRepositoryRef ref,
) =>
    GrandPrixResultsRepositoryImpl(
      firebaseGrandPrixResultsService: ref.read(
        firebaseGrandPrixResultsServiceProvider,
      ),
    );
