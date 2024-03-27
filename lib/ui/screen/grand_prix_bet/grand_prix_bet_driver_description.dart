import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../model/driver.dart';
import '../../component/gap/gap_horizontal.dart';
import '../../component/text/body.dart';
import '../../component/text_component.dart';
import 'provider/driver_provider.dart';

class DriverDescription extends ConsumerWidget {
  final String? driverId;

  const DriverDescription({super.key, required this.driverId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Driver? driver;
    if (driverId != null) {
      driver = ref.watch(driverProvider(driverId: driverId!)).value;
    }

    return driver != null
        ? Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 8,
                height: 20,
                color: Color(driver.team.hexColor),
              ),
              const GapHorizontal4(),
              SizedBox(
                width: 25,
                child: BodyMedium(
                  '${driver.number}',
                  textAlign: TextAlign.center,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const GapHorizontal4(),
              TitleMedium('${driver.name} ${driver.surname}'),
            ],
          )
        : const Center(
            child: TitleMedium(
              '--',
              fontWeight: FontWeight.bold,
            ),
          );
  }
}
