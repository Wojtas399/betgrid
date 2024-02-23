import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../auth/auth_service.dart';
import '../../../data/repository/grand_prix/grand_prix_repository.dart';
import '../../../model/grand_prix.dart';

part 'all_grand_prixes_provider.g.dart';

@riverpod
Future<List<GrandPrix>?> allGrandPrixes(AllGrandPrixesRef ref) async {
  final String? loggedUserId =
      await ref.read(authServiceProvider).loggedUserId$.first;
  if (loggedUserId == null) return null;
  final List<GrandPrix> grandPrixes =
      await ref.read(grandPrixRepositoryProvider).loadAllGrandPrixes();
  grandPrixes.sort(
    (GrandPrix gp1, GrandPrix gp2) => gp1.startDate.compareTo(gp2.startDate),
  );
  return grandPrixes;
}
