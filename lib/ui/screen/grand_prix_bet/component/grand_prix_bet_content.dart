import 'package:flutter/material.dart';

import 'grand_prix_bet_app_bar.dart';
import 'grand_prix_bet_body.dart';

class GrandPrixBetContent extends StatelessWidget {
  const GrandPrixBetContent({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: GrandPrixBetAppBar(),
      body: SafeArea(child: GrandPrixBetBody()),
    );
  }
}
