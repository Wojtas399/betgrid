import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../data/repository/grand_prix/grand_prix_repository.dart';
import '../../../../model/grand_prix.dart';

part 'all_grand_prixes_provider.g.dart';

@riverpod
Stream<List<GrandPrix>?> allGrandPrixes(AllGrandPrixesRef ref) async* {
  final Stream<List<GrandPrix>?> grandPrixes$ =
      ref.read(grandPrixRepositoryProvider).getAllGrandPrixes();
  await for (final grandPrixes in grandPrixes$) {
    if (grandPrixes == null) yield null;
    final sortedGrandPrixes = [...?grandPrixes];
    sortedGrandPrixes.sort(
      (GrandPrix gp1, GrandPrix gp2) => gp1.startDate.compareTo(gp2.startDate),
    );
    yield sortedGrandPrixes;
  }
}
