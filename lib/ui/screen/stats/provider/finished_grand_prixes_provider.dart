import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../data/repository/grand_prix/grand_prix_repository.dart';
import '../../../../dependency_injection.dart';
import '../../../../model/grand_prix.dart';
import '../../../service/date_service.dart';

part 'finished_grand_prixes_provider.g.dart';

@riverpod
Future<List<GrandPrix>> finishedGrandPrixes(
  FinishedGrandPrixesRef ref,
) async {
  final allGrandPrixes =
      await getIt.get<GrandPrixRepository>().getAllGrandPrixes().first;
  if (allGrandPrixes == null) return [];
  final now = ref.watch(dateServiceProvider).getNow();
  return allGrandPrixes.where((gp) => gp.startDate.isBefore(now)).toList();
}
