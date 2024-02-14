import 'package:flutter/material.dart';

import '../../../../model/driver.dart';
import '../../../component/gap/gap_horizontal.dart';
import '../../../component/text/body.dart';
import '../../../component/text/title.dart';

class GrandPrixBetDriverDescription extends StatelessWidget {
  final Driver driver;

  const GrandPrixBetDriverDescription({super.key, required this.driver});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 20,
          color: Color(driver.team.hexColor),
        ),
        const GapHorizontal8(),
        SizedBox(
          width: 25,
          child: BodyMedium(
            '${driver.number}',
            textAlign: TextAlign.center,
            fontWeight: FontWeight.bold,
          ),
        ),
        const GapHorizontal16(),
        TitleMedium('${driver.name} ${driver.surname}'),
      ],
    );
  }
}
