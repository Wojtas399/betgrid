import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../model/grand_prix.dart';
import 'grand_prix_repository_impl.dart';

part 'grand_prix_repository.g.dart';

@riverpod
GrandPrixRepository grandPrixRepository(GrandPrixRepositoryRef ref) =>
    GrandPrixRepositoryImpl();

abstract interface class GrandPrixRepository {
  Future<List<GrandPrix>> loadAllGrandPrixes();
}
