import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../component/sliver_grand_prixes_list_component.dart';
import '../../component/sliver_player_total_points_component.dart';
import '../../provider/logged_user_provider.dart';

@RoutePage()
class BetsScreen extends ConsumerWidget {
  const BetsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String? loggedUserId = ref.watch(
      loggedUserProvider.select((state) => state.value?.id),
    );

    return loggedUserId != null
        ? CustomScrollView(
            slivers: [
              SliverPlayerTotalPoints(playerId: loggedUserId),
              SliverGrandPrixesList(playerId: loggedUserId),
            ],
          )
        : const CircularProgressIndicator();
  }
}
