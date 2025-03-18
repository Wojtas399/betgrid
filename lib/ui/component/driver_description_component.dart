import 'package:flutter/material.dart';

import '../../model/driver_details.dart';
import '../extensions/build_context_extensions.dart';
import '../extensions/string_extensions.dart';
import 'gap/gap_horizontal.dart';
import 'text_component.dart';

class DriverDescription extends StatelessWidget {
  final DriverDetails driverDetails;
  final bool boldedSurname;

  const DriverDescription({
    super.key,
    required this.driverDetails,
    this.boldedSurname = true,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 4,
          height: 25,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: driverDetails.teamHexColor.toColor(),
          ),
        ),
        const GapHorizontal8(),
        SizedBox(
          width: 20.0,
          child: Center(
            child: BodyMedium(
              driverDetails.number > 0 ? '${driverDetails.number}' : 'R',
            ),
          ),
        ),
        const GapHorizontal16(),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LabelSmall(
              driverDetails.teamName,
              color: context.colorScheme.outline,
            ),
            Row(
              children: [
                BodyMedium(driverDetails.name),
                const GapHorizontal4(),
                BodyMedium(
                  driverDetails.surname,
                  fontWeight:
                      boldedSurname ? FontWeight.bold : FontWeight.normal,
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
