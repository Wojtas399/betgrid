import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../data/repository/grand_prix/grand_prix_repository_method_providers.dart';
import '../../../../model/grand_prix.dart';
import '../../../service/date_service.dart';

part 'finished_grand_prixes_provider.g.dart';

@riverpod
Future<List<GrandPrix>> finishedGrandPrixes(
  FinishedGrandPrixesRef ref,
) async {
  final allGrandPrixes = await ref.watch(allGrandPrixesProvider.future);
  if (allGrandPrixes == null) return [];
  final now = ref.watch(dateServiceProvider).getNow();
  return allGrandPrixes.where((gp) => gp.startDate.isBefore(now)).toList();
}
