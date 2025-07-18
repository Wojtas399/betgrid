import 'package:flutter/material.dart';

import '../../../component/gap/gap_horizontal.dart';
import '../../../component/text_component.dart';

class SeasonGrandPrixResultsEditorDriverDescription extends StatelessWidget {
  final String name;
  final String surname;
  final int number;
  final Color teamColor;

  const SeasonGrandPrixResultsEditorDriverDescription({
    super.key,
    required this.name,
    required this.surname,
    required this.number,
    required this.teamColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 4,
          height: 20,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: teamColor,
          ),
        ),
        const GapHorizontal8(),
        BodyMedium('$number'),
        const GapHorizontal16(),
        BodyMedium(name),
        const GapHorizontal4(),
        BodyMedium(surname),
      ],
    );
  }
}
