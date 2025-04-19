import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../component/text_component.dart';
import '../../../extensions/build_context_extensions.dart';
import '../../players/players_screen.dart';
import '../../season_grand_prix_bets/season_grand_prix_bets_screen.dart';
import '../../stats/stats_screen.dart';
import '../../season_teams/season_teams_screen.dart';
import '../cubit/home_cubit.dart';
import '../cubit/home_state.dart';
import 'home_app_bar.dart';

class HomeLoadedContent extends StatelessWidget {
  HomeLoadedContent({super.key});

  final List<Widget> _pages = [
    const SeasonGrandPrixBetsScreen(),
    const StatsScreen(),
    const PlayersScreen(),
    const SeasonTeamsScreen(),
  ];

  void _changePage(HomePage page, BuildContext context) {
    context.read<HomeCubit>().changePage(page);
    context.maybePop();
  }

  @override
  Widget build(BuildContext context) {
    final HomePage selectedPage = context.select(
      (HomeCubit cubit) => cubit.state.loaded.selectedPage,
    );

    return Scaffold(
      appBar: const HomeAppBar(),
      body: SafeArea(child: _pages[selectedPage.index]),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const _DrawerHeader(),
            ListTile(
              title: Text(context.str.seasonGrandPrixBetsScreenTitle),
              leading: const Icon(Icons.view_stream),
              selected: selectedPage == HomePage.bets,
              onTap: () => _changePage(HomePage.bets, context),
            ),
            ListTile(
              title: Text(context.str.statsScreenTitle),
              leading: const Icon(Icons.bar_chart_rounded),
              selected: selectedPage == HomePage.stats,
              onTap: () => _changePage(HomePage.stats, context),
            ),
            ListTile(
              title: Text(context.str.playersScreenTitle),
              leading: const Icon(Icons.people_rounded),
              selected: selectedPage == HomePage.players,
              onTap: () => _changePage(HomePage.players, context),
            ),
            ListTile(
              title: Text(context.str.seasonTeamsScreenTitle),
              leading: const Icon(Icons.info),
              selected: selectedPage == HomePage.teamsDetails,
              onTap: () => _changePage(HomePage.teamsDetails, context),
            ),
          ],
        ),
      ),
    );
  }
}

class _DrawerHeader extends StatelessWidget {
  const _DrawerHeader();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).padding.top + 80,
      child: DrawerHeader(
        decoration: BoxDecoration(color: context.colorScheme.primaryContainer),
        child: const Align(alignment: Alignment.bottomLeft, child: _Logo()),
      ),
    );
  }
}

class _Logo extends StatelessWidget {
  const _Logo();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        HeadlineMedium('Bet', fontWeight: FontWeight.bold),
        HeadlineMedium('Grid', color: Colors.red, fontWeight: FontWeight.bold),
      ],
    );
  }
}
