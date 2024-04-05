import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../model/grand_prix.dart';
import 'grand_prix_repository_impl.dart';

part 'grand_prix_repository.g.dart';

abstract interface class GrandPrixRepository {
  Stream<List<GrandPrix>?> getAllGrandPrixes();

  Stream<GrandPrix?> getGrandPrixById({required String grandPrixId});
}

@Riverpod(keepAlive: true)
GrandPrixRepository grandPrixRepository(GrandPrixRepositoryRef ref) =>
    GrandPrixRepositoryImpl();
