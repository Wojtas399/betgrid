import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/repository/grand_prix/grand_prix_repository.dart';
import '../../../model/grand_prix.dart';

part 'all_grand_prixes_provider.g.dart';

@riverpod
Future<List<GrandPrix>?> allGrandPrixes(AllGrandPrixesRef ref) async {
  final List<GrandPrix> grandPrixes =
      await ref.read(grandPrixRepositoryProvider).loadAllGrandPrixes();
  grandPrixes.sort(
    (GrandPrix gp1, GrandPrix gp2) => gp1.startDate.compareTo(gp2.startDate),
  );
  return grandPrixes;
}
