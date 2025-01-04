import 'package:flutter/material.dart';

import '../../../component/custom_card_component.dart';
import '../../../component/gap/gap_vertical.dart';
import '../../../component/text_component.dart';
import '../../../extensions/build_context_extensions.dart';
import 'grand_prix_bet_editor_app_bar.dart';
import 'grand_prix_bet_editor_quali.dart';
import 'grand_prix_bet_editor_race.dart';

class GrandPrixBetEditorContent extends StatelessWidget {
  const GrandPrixBetEditorContent({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: const GrandPrixBetEditorAppBar(),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _Section(
                    title: context.str.qualifications,
                    subtitle:
                        context.str.grandPrixBetEditorQualificationDescription,
                    body: const GrandPrixBetEditorQuali(),
                  ),
                  const GapVertical24(),
                  _Section(
                    title: context.str.race,
                    subtitle: context.str.grandPrixBetEditorRaceDescription,
                    body: const GrandPrixBetEditorRace(),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}

class _Section extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget body;

  const _Section({
    required this.title,
    required this.subtitle,
    required this.body,
  });

  @override
  Widget build(BuildContext context) => CustomCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TitleLarge(
              title,
              fontWeight: FontWeight.bold,
            ),
            const GapVertical4(),
            BodyMedium(subtitle),
            const GapVertical16(),
            body,
          ],
        ),
      );
}
