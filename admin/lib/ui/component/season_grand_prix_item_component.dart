import 'package:flutter/material.dart';

import '../../model/season_grand_prix_details.dart';
import '../extensions/build_context_extensions.dart';
import '../extensions/datetime_extensions.dart';
import 'custom_country_flag_component.dart';
import 'padding_component.dart';
import 'text_component.dart';

class SeasonGrandPrixItem extends StatelessWidget {
  final SeasonGrandPrixDetails seasonGrandPrixDetails;

  const SeasonGrandPrixItem({super.key, required this.seasonGrandPrixDetails});

  @override
  Widget build(BuildContext context) {
    return Padding16(
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LabelLarge(
                  'Runda ${seasonGrandPrixDetails.roundNumber}',
                  color: context.colorScheme.outline,
                ),
                TitleMedium(seasonGrandPrixDetails.grandPrixName),
                BodyMedium(
                  '${seasonGrandPrixDetails.startDate.toDayAndMonthName()} - ${seasonGrandPrixDetails.endDate.toDayAndMonthName()}',
                ),
              ],
            ),
          ),
          CustomCountryFlag(
            countryAlpha2Code: seasonGrandPrixDetails.countryAlpha2Code,
          ),
        ],
      ),
    );
  }
}
