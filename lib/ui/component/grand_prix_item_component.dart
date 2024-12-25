import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';

import '../../model/grand_prix.dart';
import '../extensions/build_context_extensions.dart';
import '../service/formatter_service.dart';
import 'gap/gap_horizontal.dart';
import 'padding/padding_components.dart';
import 'text_component.dart';

class GrandPrixItem extends StatelessWidget {
  final double? betPoints;
  final GrandPrix grandPrix;
  final VoidCallback onPressed;

  const GrandPrixItem({
    super.key,
    this.betPoints,
    required this.grandPrix,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) => _Card(
        onPressed: onPressed,
        child: Row(
          children: [
            _CountryFlag(
              countryAlpha2Code: grandPrix.countryAlpha2Code,
            ),
            const GapHorizontal16(),
            Expanded(
              child: _GrandPrixDescription(
                roundNumber: grandPrix.roundNumber,
                gpName: grandPrix.name,
                startDate: grandPrix.startDate,
                endDate: grandPrix.endDate,
              ),
            ),
            _BetPoints(points: betPoints),
            const GapHorizontal4(),
          ],
        ),
      );
}

class _Card extends StatelessWidget {
  final Widget child;
  final VoidCallback onPressed;

  const _Card({
    required this.child,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) => SizedBox(
        width: double.infinity,
        child: Card(
          color: context.colorScheme.surfaceContainer,
          shape: RoundedRectangleBorder(
            side: BorderSide(
              color: context.colorScheme.surfaceContainerHighest,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          clipBehavior: Clip.hardEdge,
          child: InkWell(
            onTap: onPressed,
            child: Padding16(
              child: child,
            ),
          ),
        ),
      );
}

class _CountryFlag extends StatelessWidget {
  final String countryAlpha2Code;

  const _CountryFlag({
    required this.countryAlpha2Code,
  });

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: context.colorScheme.outline.withValues(
              alpha: 0.5,
            ),
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(9),
          child: CountryFlag.fromCountryCode(countryAlpha2Code),
        ),
      );
}

class _GrandPrixDescription extends StatelessWidget {
  final int roundNumber;
  final String gpName;
  final DateTime startDate;
  final DateTime endDate;

  const _GrandPrixDescription({
    required this.roundNumber,
    required this.gpName,
    required this.startDate,
    required this.endDate,
  });

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BodyMedium(
            '${context.str.round} $roundNumber',
            fontWeight: FontWeight.w300,
          ),
          TitleMedium(gpName),
          BodyMedium(
            '${startDate.toDayAndMonthName()} - ${endDate.toDayAndMonthName()}',
          ),
        ],
      );
}

class _BetPoints extends StatelessWidget {
  final double? points;

  const _BetPoints({
    this.points,
  });

  @override
  Widget build(BuildContext context) => Column(
        children: [
          LabelLarge(
            context.str.points,
            fontWeight: FontWeight.w300,
          ),
          TitleMedium('${points ?? '--'}'),
        ],
      );
}
