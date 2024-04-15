import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../data/repository/grand_prix/grand_prix_repository_method_providers.dart';
import '../../../../model/grand_prix.dart';
import '../../../provider/grand_prix_id_provider.dart';

part 'grand_prix_name_provider.g.dart';

@Riverpod(dependencies: [grandPrixId])
Future<String?> grandPrixName(GrandPrixNameRef ref) async {
  final String? grandPrixId = ref.watch(grandPrixIdProvider);
  return grandPrixId != null
      ? await ref.watch(
          grandPrixProvider(grandPrixId: grandPrixId).selectAsync(
            (GrandPrix? grandPrix) => grandPrix?.name,
          ),
        )
      : null;
}
