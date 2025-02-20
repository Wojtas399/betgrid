import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../model/driver_details.dart';
import '../../../component/gap/gap_horizontal.dart';
import '../../../component/text_component.dart';
import '../../../extensions/build_context_extensions.dart';
import '../../../extensions/string_extensions.dart';
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
      child: DropdownButton<String>(
        isExpanded: true,
        value: _selectedDriverId,
        hint: Text(context.str.statsSelectDriver),
        items:
            allDrivers
                ?.map((DriverDetails driver) => _DriverDescription(driver))
                .toList(),
        onChanged: (String? driverId) => _onDriverChanged(driverId),
      ),
    );
  }
}

class _DriverDescription extends DropdownMenuItem<String> {
  final DriverDetails driver;

  _DriverDescription(this.driver)
    : super(
        value: driver.seasonDriverId,
        child: Row(
          children: [
            Container(
              color: driver.teamHexColor.toColor(),
              width: 6,
              height: 20,
            ),
            const GapHorizontal16(),
            TitleMedium('${driver.number}'),
            const GapHorizontal16(),
            BodyLarge('${driver.name} ${driver.surname}'),
          ],
        ),
      );
}
