import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/repository/grand_prix/grand_prix_repository.dart';
import '../../../model/grand_prix.dart';

part 'grand_prix_provider.g.dart';

@riverpod
Future<GrandPrix?> grandPrix(GrandPrixRef ref, String grandPrixId) => ref
    .watch(grandPrixRepositoryProvider)
    .loadGrandPrixById(grandPrixId: grandPrixId);
