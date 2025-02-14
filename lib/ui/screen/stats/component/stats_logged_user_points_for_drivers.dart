import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../component/driver_description_component.dart';
import '../../../component/text_component.dart';
import '../../../extensions/string_extensions.dart';
import '../cubit/stats_cubit.dart';
import '../cubit/stats_state.dart';
import '../stats_model/points_for_driver.dart';
import 'stats_no_data_info.dart';

class StatsLoggedUserPointsForDrivers extends StatelessWidget {
  const StatsLoggedUserPointsForDrivers({super.key});

  @override
  Widget build(BuildContext context) {
    final List<PointsForDriver>? pointsForDrivers = context.select(
      (StatsCubit cubit) =>
          (cubit.state.stats as IndividualStats).pointsForDrivers,
    );

    return pointsForDrivers != null
        ? Column(
          spacing: 16.0,
          children: [
            for (final pointsForDriver in pointsForDrivers)
              _DriverInfo(pointsForDriver: pointsForDriver),
          ],
        )
        : const SizedBox(height: 300, child: StatsNoDataInfo());
  }
}

class _DriverInfo extends StatelessWidget {
  final PointsForDriver pointsForDriver;

  const _DriverInfo({required this.pointsForDriver});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        DriverDescription(
          name: pointsForDriver.driverDetails.name,
          surname: pointsForDriver.driverDetails.surname,
          number: pointsForDriver.driverDetails.number,
          teamColor: pointsForDriver.driverDetails.teamHexColor.toColor(),
          boldedSurname: false,
        ),
        BodyMedium('${pointsForDriver.points}'),
      ],
    );
  }
}
