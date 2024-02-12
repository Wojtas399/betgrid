import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import '../../model/driver.dart';
import '../extensions/build_context_extensions.dart';

class DriverDropdownButton extends StatefulWidget {
  final String? selectedDriverId;
  final List<Driver> allDrivers;
  final Function(String) onDriverSelected;

  const DriverDropdownButton({
    super.key,
    required this.selectedDriverId,
    required this.allDrivers,
    required this.onDriverSelected,
  });

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<DriverDropdownButton> {
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
