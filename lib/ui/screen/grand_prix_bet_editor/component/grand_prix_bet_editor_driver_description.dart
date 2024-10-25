import 'package:flutter/material.dart';

import '../../../../model/driver.dart';
import '../../../component/gap/gap_horizontal.dart';
import '../../../component/text_component.dart';

class GrandPrixBetEditorDriverDescription extends StatelessWidget {
  final Driver driver;

  const GrandPrixBetEditorDriverDescription({
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
            color: Color(driver.team.hexColor),
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
