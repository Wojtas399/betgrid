import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../model/driver.dart';
import '../../../component/gap/gap_horizontal.dart';
import '../../../component/text/body.dart';
import '../../../component/text/title.dart';
import '../../../extensions/build_context_extensions.dart';
import '../../../provider/bet_mode_provider.dart';
import 'grand_prix_bet_label_cell.dart';

class GrandPrixBetPositionItem extends TableRow {
  const GrandPrixBetPositionItem({super.key, super.children});

  factory GrandPrixBetPositionItem.build({
    required BuildContext context,
    required String label,
    Color? labelBackgroundColor,
    required String? selectedDriverId,
    required List<Driver> allDrivers,
    List<String> selectedDriverIds = const [],
    required Function(String) onDriverSelected,
  }) {
    return GrandPrixBetPositionItem(
      children: [
        GrandPrixBetLabelCell.build(
          context: context,
          label: label,
          labelBackgroundColor: labelBackgroundColor,
        ),
        TableCell(
          verticalAlignment: TableCellVerticalAlignment.middle,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 16, 8),
            child: _ValueCell(
              selectedDriverId: selectedDriverId,
              allDrivers: allDrivers,
              selectedDriverIds: selectedDriverIds,
              onDriverSelected: onDriverSelected,
            ),
          ),
        ),
      ],
    );
  }
}

class _ValueCell extends ConsumerWidget {
  final String? selectedDriverId;
  final List<Driver> allDrivers;
  final List<String> selectedDriverIds;
  final Function(String) onDriverSelected;

  const _ValueCell({
    required this.selectedDriverId,
    required this.allDrivers,
    this.selectedDriverIds = const [],
    required this.onDriverSelected,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final betMode = ref.watch(betModeProvider);

    return switch (betMode) {
      BetMode.edit => _DropdownButton(
          selectedDriverId: selectedDriverId,
          allDrivers: allDrivers,
          selectedDriverIds: selectedDriverIds,
          onDriverSelected: onDriverSelected,
        ),
      BetMode.preview => _DriverDescription(
          driver: allDrivers.firstWhereOrNull(
            (driver) => driver.id == selectedDriverId,
          ),
        ),
    };
  }
}

class _DropdownButton extends StatefulWidget {
  final String? selectedDriverId;
  final List<Driver> allDrivers;
  final List<String> selectedDriverIds;
  final Function(String) onDriverSelected;

  const _DropdownButton({
    required this.selectedDriverId,
    required this.allDrivers,
    required this.selectedDriverIds,
    required this.onDriverSelected,
  });

  @override
  State<StatefulWidget> createState() => _DropdownButtonState();
}

class _DropdownButtonState extends State<_DropdownButton> {
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
  void didUpdateWidget(covariant _DropdownButton oldWidget) {
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
      value: _selectedDriver,
      hint: Text(context.str.grandPrixBetSelectDriver),
      selectedItemBuilder: (_) => _sortedDrivers
          .map((Driver driver) => _DriverDescription(driver: driver))
          .toList(),
      items: _sortedDrivers
          .map(
            (Driver driver) => DropdownMenuItem<Driver>(
              value: driver,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _DriverDescription(driver: driver),
                  if (widget.selectedDriverIds.contains(driver.id))
                    const Icon(
                      Icons.do_not_disturb_on_outlined,
                      size: 16,
                    ),
                ],
              ),
            ),
          )
          .toList(),
      onChanged: _onDriverSelected,
    );
  }
}

class _DriverDescription extends StatelessWidget {
  final Driver? driver;

  const _DriverDescription({required this.driver});

  @override
  Widget build(BuildContext context) {
    return driver != null
        ? Row(
            children: [
              Container(
                width: 8,
                height: 20,
                color: Color(driver!.team.hexColor),
              ),
              const GapHorizontal4(),
              SizedBox(
                width: 25,
                child: BodyMedium(
                  '${driver!.number}',
                  textAlign: TextAlign.center,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const GapHorizontal8(),
              TitleMedium('${driver!.name} ${driver!.surname}'),
            ],
          )
        : const Center(
            child: TitleMedium(
              '--',
              fontWeight: FontWeight.bold,
            ),
          );
  }
}
