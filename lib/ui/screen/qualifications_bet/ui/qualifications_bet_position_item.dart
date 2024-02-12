import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../model/driver.dart';
import '../../../component/gap/gap_horizontal.dart';
import '../../../component/text/title.dart';
import '../../../extensions/build_context_extensions.dart';

class QualificationsBetPositionItem extends StatelessWidget {
  final int position;
  final String? selectedDriverId;
  final List<Driver> allDrivers;
  final Function(String) onDriverSelected;

  const QualificationsBetPositionItem({
    super.key,
    required this.position,
    required this.selectedDriverId,
    required this.allDrivers,
    required this.onDriverSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Row(
        children: [
          TitleMedium('$position.'),
          const GapHorizontal16(),
          Expanded(
            child: _DriverDropdownButton(
              selectedDriverId: selectedDriverId,
              allDrivers: allDrivers,
              onDriverSelected: onDriverSelected,
            ),
          ),
        ],
      ),
    );
  }
}

class _DriverDropdownButton extends ConsumerStatefulWidget {
  final String? selectedDriverId;
  final List<Driver> allDrivers;
  final Function(String) onDriverSelected;

  const _DriverDropdownButton({
    required this.selectedDriverId,
    required this.allDrivers,
    required this.onDriverSelected,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _DriverDropdownButtonState();
}

class _DriverDropdownButtonState extends ConsumerState<_DriverDropdownButton> {
  Driver? _selectedDriver;
  late List<Driver> _sortedDrivers;

  @override
  void initState() {
    final List<Driver> sortedDrivers = [...widget.allDrivers];
    sortedDrivers.sort(
      (Driver d1, Driver d2) => d1.surname.compareTo(d2.surname),
    );
    _selectedDriver = sortedDrivers.firstWhereOrNull(
      (Driver driver) => driver.id == widget.selectedDriverId,
    );
    _sortedDrivers = sortedDrivers;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<Driver>(
      decoration: const InputDecoration(
        border: InputBorder.none,
      ),
      value: _selectedDriver,
      hint: Text(context.str.qualificationsBetSelectDriver),
      items: _sortedDrivers
          .map(
            (driver) => DropdownMenuItem<Driver>(
              value: driver,
              child: Text('${driver.surname} ${driver.name}'),
            ),
          )
          .toList(),
      onChanged: (Driver? selectedDriver) {
        if (selectedDriver != null) {
          setState(() {
            _selectedDriver = selectedDriver;
          });
          widget.onDriverSelected(selectedDriver.id);
        }
      },
    );
  }
}
