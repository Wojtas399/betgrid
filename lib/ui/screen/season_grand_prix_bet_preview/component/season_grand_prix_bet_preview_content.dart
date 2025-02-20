import 'package:flutter/material.dart';

import 'season_grand_prix_bet_preview_app_bar.dart';
import 'season_grand_prix_bet_preview_body.dart';

class GrandPrixBetContent extends StatelessWidget {
  const GrandPrixBetContent({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: SeasonGrandPrixBetPreviewAppBar(),
      body: SafeArea(child: SeasonGrandPrixBetPreviewBody()),
    );
  }
}
