import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../model/driver.dart';
import '../../../component/gap/gap_horizontal.dart';
import '../../../component/text_component.dart';
import '../../../extensions/build_context_extensions.dart';
import '../cubit/stats_cubit.dart';
import '../cubit/stats_state.dart';

class StatsPointsByDriverDropdownButton extends StatefulWidget {
  const StatsPointsByDriverDropdownButton({super.key});

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<StatsPointsByDriverDropdownButton> {
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
    final bool isCubitLoading = context.select(
      (StatsCubit cubit) => cubit.state.status.isLoading,
    );
    final Iterable<Driver>? allDrivers = context.select(
      (StatsCubit cubit) => cubit.state.allDrivers,
    );

    return isCubitLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : SizedBox(
            width: double.infinity,
            child: DropdownButton<String>(
              isExpanded: true,
              value: _selectedDriverId,
              hint: Text(context.str.statsSelectDriver),
              items: allDrivers
                  ?.map((Driver driver) => _DriverDescription(driver))
                  .toList(),
              onChanged: (String? driverId) => _onDriverChanged(driverId),
            ),
          );
  }
}

class _DriverDescription extends DropdownMenuItem<String> {
  final Driver driver;

  _DriverDescription(this.driver)
      : super(
          value: driver.id,
          child: Row(
            children: [
              Container(
                color: Color(driver.team.hexColor),
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
