import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../model/driver.dart';
import '../../../component/gap/gap_horizontal.dart';
import '../../../component/text/title.dart';
import '../../../extensions/build_context_extensions.dart';
import '../../../riverpod_provider/all_drivers_provider.dart';
import '../notifier/grand_prix_bet_notifier.dart';
import 'grand_prix_bet_position_item.dart';
import 'grand_prix_bet_table.dart';

class GrandPrixBetAdditional extends ConsumerWidget {
  const GrandPrixBetAdditional({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<Driver>?> allDrivers = ref.watch(allDriversProvider);
    final gpBetNotifier = ref.read(grandPrixBetNotifierProvider.notifier);
    final List<String?>? dnfDriverIds = ref.watch(
      grandPrixBetNotifierProvider.select(
        (state) => state.value?.dnfDriverIds,
      ),
    );
    final bool? willBeSafetyCar = ref.watch(
      grandPrixBetNotifierProvider.select(
        (state) => state.value?.willBeSafetyCar,
      ),
    );
    final bool? willBeRedFlag = ref.watch(
      grandPrixBetNotifierProvider.select(
        (state) => state.value?.willBeRedFlag,
      ),
    );

    return GrandPrixBetTable(
      rows: [
        ...List.generate(
          3,
          (index) => GrandPrixBetPositionItem.build(
            label: switch (index) {
              0 => 'DNF',
              1 => 'DNF',
              2 => 'DNF',
              _ => '',
            },
            selectedDriverId: dnfDriverIds![index],
            allDrivers: allDrivers.value!,
            onDriverSelected: (String driverId) {
              gpBetNotifier.onDnfDriverChanged(index, driverId);
            },
          ),
        ),
        _YesAndNoButtons.build(
          label: 'SC',
          initialValue: willBeSafetyCar,
          onChanged: gpBetNotifier.onSafetyCarPossibilityChanged,
        ),
        _YesAndNoButtons.build(
          label: 'RF',
          initialValue: willBeRedFlag,
          onChanged: gpBetNotifier.onRedFlagPossibilityChanged,
        ),
      ],
    );
  }
}

class _YesAndNoButtons extends TableRow {
  const _YesAndNoButtons({super.children});

  factory _YesAndNoButtons.build({
    required String label,
    required bool? initialValue,
    required Function(bool) onChanged,
  }) {
    return _YesAndNoButtons(
      children: [
        TableCell(
          verticalAlignment: TableCellVerticalAlignment.middle,
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: TitleMedium(label),
            ),
          ),
        ),
        TableCell(
          verticalAlignment: TableCellVerticalAlignment.middle,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: _YesOrNoSelection(
              initialValue: initialValue,
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}

class _YesOrNoSelection extends StatefulWidget {
  final bool? initialValue;
  final Function(bool) onChanged;

  const _YesOrNoSelection({
    required this.initialValue,
    required this.onChanged,
  });

  @override
  State<StatefulWidget> createState() => _YesOrNoSelectionState();
}

class _YesOrNoSelectionState extends State<_YesOrNoSelection> {
  bool? selectedOption;

  @override
  void initState() {
    selectedOption = widget.initialValue;
    super.initState();
  }

  void _onYesPressed() {
    setState(() {
      selectedOption = true;
    });
    widget.onChanged(true);
  }

  void _onNoPressed() {
    setState(() {
      selectedOption = false;
    });
    widget.onChanged(false);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _SelectableButton(
            label: context.str.yes,
            isSelected: selectedOption == true,
            onPressed: _onYesPressed,
          ),
        ),
        const GapHorizontal32(),
        Expanded(
          child: _SelectableButton(
            label: context.str.no,
            isSelected: selectedOption == false,
            onPressed: _onNoPressed,
          ),
        ),
      ],
    );
  }
}

class _SelectableButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onPressed;

  const _SelectableButton({
    required this.label,
    required this.isSelected,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return isSelected == true
        ? ElevatedButton(
            onPressed: onPressed,
            child: Text(label),
          )
        : OutlinedButton(
            onPressed: onPressed,
            child: Text(label),
          );
  }
}
