import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../model/driver_details.dart';
import '../../../component/driver_description_component.dart';
import '../../../extensions/build_context_extensions.dart';
import '../cubit/stats_cubit.dart';
import '../cubit/stats_state.dart';

class StatsPlayersPointsForDriverDropdownButton extends StatefulWidget {
  const StatsPlayersPointsForDriverDropdownButton({super.key});

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<StatsPlayersPointsForDriverDropdownButton> {
  String? _selectedDriverId;

  void _onDriverChanged(String? driverId) {
    if (driverId != null) {
      context.read<StatsCubit>().onDriverChanged(driverId);
      setState(() {
        _selectedDriverId = driverId;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final Iterable<DriverDetails>? allDrivers = context.select(
      (StatsCubit cubit) =>
          (cubit.state.stats as GroupedStats).detailsOfDriversFromSeason,
    );

    return SizedBox(
      width: double.infinity,
      child: DropdownButtonFormField<String>(
        isDense: false,
        value: _selectedDriverId,
        decoration: const InputDecoration(fillColor: Colors.transparent),
        hint: Text(context.str.statsSelectDriver),
        items:
            allDrivers
                ?.map(
                  (DriverDetails driver) => DropdownMenuItem<String>(
                    value: driver.seasonDriverId,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: DriverDescription(driverDetails: driver),
                    ),
                  ),
                )
                .toList(),
        onChanged: (String? driverId) => _onDriverChanged(driverId),
      ),
    );
  }
}
