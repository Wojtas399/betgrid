import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../data/repository/grand_prix/grand_prix_repository.dart';
import '../../../../model/grand_prix.dart';
import '../state/home_state.dart';

part 'home_controller.g.dart';

@riverpod
class HomeController extends _$HomeController {
  @override
  Future<HomeState> build() async {
    final List<GrandPrix> grandPrixes =
        await ref.read(grandPrixRepositoryProvider).loadAllGrandPrixes();
    grandPrixes.sort(
      (GrandPrix gp1, GrandPrix gp2) => gp1.startDate.compareTo(gp2.startDate),
    );
    return HomeStateDataLoaded(grandPrixes: grandPrixes);
  }
}