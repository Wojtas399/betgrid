import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../data/repository/grand_prix/grand_prix_repository.dart';
import '../../../../dependency_injection.dart';
import '../../../provider/grand_prix_id_provider.dart';

part 'grand_prix_name_provider.g.dart';

@Riverpod(dependencies: [grandPrixId])
Future<String?> grandPrixName(GrandPrixNameRef ref) async {
  final String? grandPrixId = ref.watch(grandPrixIdProvider);
  return grandPrixId != null
      ? (await getIt
              .get<GrandPrixRepository>()
              .getGrandPrixById(grandPrixId: grandPrixId)
              .first)
          ?.name
      : null;
}
