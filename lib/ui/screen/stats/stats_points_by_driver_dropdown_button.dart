import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/repository/driver/driver_repository_method_providers.dart';
import '../../../model/driver.dart';
import '../../component/gap/gap_horizontal.dart';
import '../../component/text_component.dart';
import '../../extensions/build_context_extensions.dart';
import 'provider/stats_data_provider.dart';

class StatsPointsByDriverDropdownButton extends ConsumerStatefulWidget {
  const StatsPointsByDriverDropdownButton({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _State();
}

class _State extends ConsumerState<StatsPointsByDriverDropdownButton> {
  String? _selectedDriverId;

  void _onDriverChanged(String? driverId, WidgetRef ref) {
    if (driverId != null) {
      ref.read(statsProvider.notifier).onDriverChanged(driverId);
      setState(() {
        _selectedDriverId = driverId;
      });
    }
  }

  @override
  Widget build(BuildContext context) => ref.watch(allDriversProvider).when(
        data: (List<Driver> allDrivers) {
          allDrivers.sort(
            (d1, d2) => d1.team.toString().compareTo(d2.team.toString()),
          );

          return SizedBox(
            width: double.infinity,
            child: DropdownButton<String>(
              isExpanded: true,
              value: _selectedDriverId,
              hint: Text(context.str.statsSelectDriver),
              items: allDrivers
                  .map((Driver driver) => _DriverDescription(driver))
                  .toList(),
              onChanged: (String? driverId) => _onDriverChanged(driverId, ref),
            ),
          );
        },
        error: (Object? error, __) => Text(error.toString()),
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
      );
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
