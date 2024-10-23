import 'package:flutter/material.dart';

import '../../../component/gap/gap_vertical.dart';
import '../../../component/text_component.dart';
import '../../../config/theme/custom_colors.dart';
import '../../../extensions/build_context_extensions.dart';
import 'grand_prix_bet_editor_boolean_field.dart';
import 'grand_prix_bet_editor_driver_field.dart';

class GrandPrixBetEditorRace extends StatelessWidget {
  const GrandPrixBetEditorRace({super.key});

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionHeader(
            title: context.str.grandPrixBetEditorPodiumAndP10Title,
            subtitle: context.str.grandPrixBetEditorPodiumAndP10Subtitle,
          ),
          const GapVertical16(),
          const _PodiumAndP10(),
          const Divider(height: 32),
          _SectionHeader(
            title: context.str.grandPrixBetEditorFastestLapTitle,
            subtitle: context.str.grandPrixBetEditorFastestLapSubtitle,
          ),
          const GapVertical16(),
          const _FastestLap(),
          const Divider(height: 32),
          _SectionHeader(
            title: context.str.grandPrixBetEditorDnfTitle,
            subtitle: context.str.grandPrixBetEditorDnfSubtitle,
          ),
          const GapVertical16(),
          const _DnfDrivers(),
          const Divider(height: 32),
          _SectionHeader(
            title: context.str.grandPrixBetEditorSafetyCarTitle,
            subtitle: context.str.grandPrixBetEditorSafetyCarSubtitle,
          ),
          const GapVertical16(),
          const _SafetyCar(),
          const Divider(height: 32),
          _SectionHeader(
            title: context.str.grandPrixBetEditorRedFlagTitle,
            subtitle: context.str.grandPrixBetEditorRedFlagSubtitle,
          ),
          const GapVertical16(),
          const _RedFlag(),
        ],
      );
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String subtitle;

  const _SectionHeader({
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) => SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TitleMedium(
              title,
              fontWeight: FontWeight.bold,
            ),
            const GapVertical4(),
            BodyMedium(subtitle)
          ],
        ),
      );
}

class _PodiumAndP10 extends StatelessWidget {
  const _PodiumAndP10();

  @override
  Widget build(BuildContext context) {
    final CustomColors? customColors = context.customColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GrandPrixBetEditorDriverField(
          label: 'P1',
          labelColor: customColors?.p1,
        ),
        GrandPrixBetEditorDriverField(
          label: 'P2',
          labelColor: customColors?.p2,
        ),
        GrandPrixBetEditorDriverField(
          label: 'P3',
          labelColor: customColors?.p3,
        ),
        const GrandPrixBetEditorDriverField(
          label: 'P10',
        ),
      ],
    );
  }
}

class _FastestLap extends StatelessWidget {
  const _FastestLap();

  @override
  Widget build(BuildContext context) => const GrandPrixBetEditorDriverField();
}

class _DnfDrivers extends StatelessWidget {
  const _DnfDrivers();

  void _onAddDriverPressed(BuildContext context) {
    //TODO
  }

  @override
  Widget build(BuildContext context) => Center(
        child: OutlinedButton(
          onPressed: () => _onAddDriverPressed(context),
          child: Text(context.str.grandPrixBetEditorDnfAddDriver),
        ),
      );
}

class _SafetyCar extends StatelessWidget {
  const _SafetyCar();

  void _onAnswerChanged(bool answer, BuildContext context) {
    //TODO
  }

  @override
  Widget build(BuildContext context) => GrandPrixBetEditorBooleanField(
        onChanged: (bool answer) => _onAnswerChanged(answer, context),
      );
}

class _RedFlag extends StatelessWidget {
  const _RedFlag();

  void _onAnswerChanged(bool answer, BuildContext context) {
    //TODO
  }

  @override
  Widget build(BuildContext context) => GrandPrixBetEditorBooleanField(
        onChanged: (bool answer) => _onAnswerChanged(answer, context),
      );
}
