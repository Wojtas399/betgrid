import 'package:flutter/material.dart';

import 'gap/gap_horizontal.dart';
import 'text_component.dart';

class DriverDescription extends StatelessWidget {
  final String name;
  final String surname;
  final int number;
  final Color teamColor;
  final bool boldedSurname;

  const DriverDescription({
    super.key,
    required this.name,
    required this.surname,
    required this.number,
    required this.teamColor,
    this.boldedSurname = true,
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
        SizedBox(width: 20.0, child: Center(child: BodyMedium('$number'))),
        const GapHorizontal16(),
        BodyMedium(name),
        const GapHorizontal4(),
        BodyMedium(
          surname,
          fontWeight: boldedSurname ? FontWeight.bold : FontWeight.normal,
        ),
      ],
    );
  }
}
