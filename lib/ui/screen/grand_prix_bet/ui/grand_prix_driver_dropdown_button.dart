import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import '../../../../model/driver.dart';
import '../../../component/gap/gap_horizontal.dart';
import '../../../component/text/body.dart';
import '../../../extensions/build_context_extensions.dart';

class GrandPrixDriverDropdownButton extends StatefulWidget {
  final String? selectedDriverId;
  final List<Driver> allDrivers;
  final Function(String) onDriverSelected;

  const GrandPrixDriverDropdownButton({
    super.key,
    required this.selectedDriverId,
    required this.allDrivers,
    required this.onDriverSelected,
  });

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<GrandPrixDriverDropdownButton> {
  Driver? _selectedDriver;
  late List<Driver> _sortedDrivers;

  @override
  void initState() {
    final List<Driver> sortedDrivers = [...widget.allDrivers];
    sortedDrivers.sort(
      (Driver d1, Driver d2) =>
          d1.team.toString().compareTo(d2.team.toString()),
    );
    _selectedDriver = sortedDrivers.firstWhereOrNull(
      (Driver driver) => driver.id == widget.selectedDriverId,
    );
    _sortedDrivers = sortedDrivers;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant GrandPrixDriverDropdownButton oldWidget) {
    setState(() {
      _selectedDriver = _sortedDrivers.firstWhereOrNull(
        (Driver driver) => driver.id == widget.selectedDriverId,
      );
    });
    super.didUpdateWidget(oldWidget);
  }

  void _onDriverSelected(Driver? selectedDriver) {
    if (selectedDriver != null) {
      setState(() {
        _selectedDriver = selectedDriver;
      });
      widget.onDriverSelected(selectedDriver.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<Driver>(
      decoration: const InputDecoration(
        border: InputBorder.none,
      ),
      value: _selectedDriver,
      hint: Text(context.str.grandPrixBetSelectDriver),
      items: _sortedDrivers
          .map(
            (driver) => DropdownMenuItem<Driver>(
              value: driver,
              child: Row(
                children: [
                  Container(
                    width: 8,
                    height: 20,
                    color: Color(driver.team.hexColor),
                  ),
                  const GapHorizontal8(),
                  SizedBox(
                    width: 25,
                    child: BodyMedium(
                      '${driver.number}',
                      textAlign: TextAlign.center,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  GapHorizontal16(),
                  Text('${driver.name} ${driver.surname}'),
                ],
              ),
            ),
          )
          .toList(),
      onChanged: _onDriverSelected,
    );
  }
}
