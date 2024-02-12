import 'package:flutter/material.dart';

import '../../../../model/driver.dart';
import '../../../component/driver_dropdown_button_component.dart';
import '../../../component/gap/gap_horizontal.dart';
import '../../../component/text/title.dart';

class GrandPrixBetPositionItem extends StatelessWidget {
  final int position;
  final String? selectedDriverId;
  final List<Driver> allDrivers;
  final Function(String) onDriverSelected;

  const GrandPrixBetPositionItem({
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
            child: DriverDropdownButton(
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
