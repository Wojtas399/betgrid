import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../config/router/app_router.dart';
import '../../extensions/build_context_extensions.dart';

@RoutePage()
class EditorsScreen extends StatelessWidget {
  const EditorsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: _Buttons());
  }
}

class _Buttons extends StatelessWidget {
  const _Buttons();

  void _navigateToDriversEditor(BuildContext context) {
    context.pushRoute(const DriversEditorRoute());
  }

  void _navigateToSeasonDriversEditor(BuildContext context) {
    context.pushRoute(const SeasonDriversEditorRoute());
  }

  void _navigateToTeamsEditor(BuildContext context) {
    context.pushRoute(const TeamsEditorRoute());
  }

  void _navigateToSeasonTeamCreator(BuildContext context) {
    context.pushRoute(const SeasonTeamsEditorRoute());
  }

  void _navigateToGrandPrixesEditor(BuildContext context) {
    context.pushRoute(const GrandPrixesEditorRoute());
  }

  void _navigateToSeasonGrandPrixesEditor(BuildContext context) {
    context.pushRoute(const SeasonGrandPrixesEditorRoute());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 24.0,
      children: [
        FilledButton(
          onPressed: () => _navigateToDriversEditor(context),
          child: Text(context.str.homeEditDriversButton),
        ),
        FilledButton(
          onPressed: () => _navigateToSeasonDriversEditor(context),
          child: Text(context.str.homeEditSeasonDriversButton),
        ),
        FilledButton(
          onPressed: () => _navigateToTeamsEditor(context),
          child: Text(context.str.homeEditTeamsButton),
        ),
        FilledButton(
          onPressed: () => _navigateToSeasonTeamCreator(context),
          child: Text(context.str.homeEditSeasonTeamsButton),
        ),
        FilledButton(
          onPressed: () => _navigateToGrandPrixesEditor(context),
          child: Text(context.str.homeEditGrandPrixesButton),
        ),
        FilledButton(
          onPressed: () => _navigateToSeasonGrandPrixesEditor(context),
          child: Text(context.str.homeEditSeasonGrandPrixesButton),
        ),
      ],
    );
  }
}
