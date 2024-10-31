import 'package:flutter/material.dart';

import '../../model/driver.dart';
import 'gap/gap_horizontal.dart';
import 'text_component.dart';

class DriverDescription extends StatelessWidget {
  final Driver driver;

  const DriverDescription({
    super.key,
    required this.driver,
  });

  @override
  Widget build(BuildContext context) => Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 4,
            height: 20,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: Color(driver.team.hexColor),
            ),
          ),
          const GapHorizontal8(),
          BodyMedium('${driver.number}'),
          const GapHorizontal16(),
          BodyMedium(driver.name),
          const GapHorizontal4(),
          BodyMedium(
            driver.surname,
            fontWeight: FontWeight.bold,
          ),
        ],
      );
}
