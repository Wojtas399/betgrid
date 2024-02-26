import 'package:auto_route/auto_route.dart';
import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';

import '../../../model/grand_prix.dart';
import '../../component/gap/gap_horizontal.dart';
import '../../component/text/body.dart';
import '../../component/text/title.dart';
import '../../config/router/app_router.dart';
import '../../service/formatter_service.dart';

class BetsGrandPrixItem extends StatelessWidget {
  final int roundNumber;
  final GrandPrix grandPrix;

  const BetsGrandPrixItem({
    super.key,
    required this.roundNumber,
    required this.grandPrix,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        color: Theme.of(context).colorScheme.primary,
        clipBehavior: Clip.hardEdge,
        child: InkWell(
          onTap: () {
            context.navigateTo(
              GrandPrixBetRoute(grandPrixId: grandPrix.id),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                _CountryFlag(
                  countryAlpha2Code: grandPrix.countryAlpha2Code,
                ),
                const GapHorizontal16(),
                Expanded(
                  child: _GrandPrixDescription(
                    roundNumber: roundNumber,
                    gpName: grandPrix.name,
                    startDate: grandPrix.startDate,
                    endDate: grandPrix.endDate,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CountryFlag extends StatelessWidget {
  final String countryAlpha2Code;

  const _CountryFlag({required this.countryAlpha2Code});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(8),
      child: CountryFlag.fromCountryCode(
        countryAlpha2Code,
        height: 48,
        width: 62,
        borderRadius: 8,
      ),
    );
  }
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
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BodyMedium(
          'Runda $roundNumber',
          color: Theme.of(context).colorScheme.outlineVariant,
          fontWeight: FontWeight.bold,
        ),
        TitleMedium(
          gpName,
          color: Theme.of(context).canvasColor,
          fontWeight: FontWeight.bold,
        ),
        BodyMedium(
          '${startDate.toDayAndMonthName()} - ${endDate.toDayAndMonthName()}',
          color: Theme.of(context).colorScheme.outlineVariant,
        ),
      ],
    );
  }
}
