import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../model/grand_prix.dart';
import 'grand_prix_repository.dart';

part 'grand_prix_repository_method_providers.g.dart';

@riverpod
Stream<GrandPrix?> grandPrix(
  GrandPrixRef ref, {
  required String grandPrixId,
}) =>
    ref
        .watch(grandPrixRepositoryProvider)
        .getGrandPrixById(grandPrixId: grandPrixId)
        .distinct();
