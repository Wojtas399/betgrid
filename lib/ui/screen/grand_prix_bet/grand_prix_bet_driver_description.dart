import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/repository/driver/driver_repository.dart';
import '../../../dependency_injection.dart';
import '../../../model/driver.dart';
import '../../component/gap/gap_horizontal.dart';
import '../../component/text_component.dart';

class DriverDescription extends ConsumerWidget {
  final String? driverId;

  const DriverDescription({super.key, required this.driverId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Stream<Driver?> driver$ = driverId != null
        ? getIt.get<DriverRepository>().getDriverById(driverId: driverId!)
        : Stream.value(null);

    return StreamBuilder(
      stream: driver$,
      builder: (_, AsyncSnapshot<Driver?> asyncSnapshot) {
        final driver = asyncSnapshot.data;
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
      },
    );
  }
}
