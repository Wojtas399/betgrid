import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../model/driver.dart';
import '../../../component/driver_description_component.dart';
import '../../../component/text_component.dart';
import '../cubit/grand_prix_bet_cubit.dart';

class GrandPrixBetDriverDescription extends StatelessWidget {
  final String? driverId;

  const GrandPrixBetDriverDescription({super.key, required this.driverId});

  @override
  Widget build(BuildContext context) {
    final Driver? driver = driverId != null
        ? context.select(
            (GrandPrixBetCubit cubit) => cubit.state.getDriverById(driverId!),
          )
        : null;

    return driver != null
        ? DriverDescription(driver: driver)
        : const TitleMedium('--');
  }
}
