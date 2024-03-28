import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/repository/auth/auth_repository_method_providers.dart';
import '../../component/sliver_grand_prixes_list_component.dart';
import '../../component/sliver_player_total_points_component.dart';

@RoutePage()
class BetsScreen extends ConsumerWidget {
  const BetsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loggedUserId = ref.watch(loggedUserIdProvider);

    return loggedUserId.isLoading
        ? const CircularProgressIndicator()
        : CustomScrollView(
            slivers: [
              SliverPlayerTotalPoints(playerId: loggedUserId.value!),
              SliverGrandPrixesList(playerId: loggedUserId.value!),
            ],
          );
  }
}
