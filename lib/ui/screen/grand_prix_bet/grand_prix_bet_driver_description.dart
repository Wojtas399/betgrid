import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../model/driver.dart';
import '../../component/gap/gap_horizontal.dart';
import '../../component/text_component.dart';
import 'cubit/grand_prix_bet_cubit.dart';

class DriverDescription extends StatelessWidget {
  final String? driverId;

  const DriverDescription({super.key, required this.driverId});

  @override
  Widget build(BuildContext context) {
    final Driver? driver = driverId != null
        ? context.select(
            (GrandPrixBetCubit cubit) => cubit.state.getDriverById(driverId!),
          )
        : null;

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
