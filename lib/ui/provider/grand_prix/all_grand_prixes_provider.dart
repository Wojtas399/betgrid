import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../data/repository/grand_prix/grand_prix_repository.dart';
import '../../../../model/grand_prix.dart';

part 'all_grand_prixes_provider.g.dart';

@riverpod
Stream<List<GrandPrix>?> allGrandPrixes(AllGrandPrixesRef ref) =>
    ref.read(grandPrixRepositoryProvider).getAllGrandPrixes();
