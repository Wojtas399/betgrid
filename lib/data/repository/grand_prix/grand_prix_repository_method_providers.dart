import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../model/grand_prix.dart';
import 'grand_prix_repository.dart';

part 'grand_prix_repository_method_providers.g.dart';

@riverpod
Stream<List<GrandPrix>?> allGrandPrixes(AllGrandPrixesRef ref) =>
    ref.watch(grandPrixRepositoryProvider).getAllGrandPrixes();
