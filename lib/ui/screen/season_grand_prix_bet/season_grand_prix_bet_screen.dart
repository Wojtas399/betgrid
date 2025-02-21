import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class SeasonGrandPrixBetScreen extends StatelessWidget {
  final int season;
  final String seasonGrandPrixId;

  const SeasonGrandPrixBetScreen({
    super.key,
    required this.season,
    required this.seasonGrandPrixId,
  });

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Text('Season Grand Prix Bet'));
  }
}
