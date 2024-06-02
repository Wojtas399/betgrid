import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../component/padding/padding_components.dart';
import '../../extensions/build_context_extensions.dart';
import 'stats_bet_points_history.dart';

class StatsBetPointsHistoryPreview extends StatefulWidget {
  const StatsBetPointsHistoryPreview({super.key});

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<StatsBetPointsHistoryPreview> {
  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    super.initState();
  }

  void _onPop() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }

  @override
  Widget build(BuildContext context) => PopScope(
        onPopInvoked: (_) => _onPop(),
        child: Dialog.fullscreen(
          child: Scaffold(
            appBar: AppBar(
              title: Text(context.str.statsPointsHistory),
            ),
            body: const SafeArea(
              child: Padding24(
                child: StatsBetPointsHistory(
                  showPointsForEachRound: true,
                ),
              ),
            ),
          ),
        ),
      );
}
