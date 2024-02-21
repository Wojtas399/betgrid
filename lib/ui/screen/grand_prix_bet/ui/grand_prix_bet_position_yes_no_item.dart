import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../component/gap/gap_horizontal.dart';
import '../../../component/text/title.dart';
import '../../../extensions/build_context_extensions.dart';
import '../../../provider/bet_mode_provider.dart';
import 'grand_prix_bet_label_cell.dart';

class GrandPrixBetPositionYesNoItem extends TableRow {
  const GrandPrixBetPositionYesNoItem({super.key, super.children});

  factory GrandPrixBetPositionYesNoItem.build({
    required BuildContext context,
    required String label,
    bool? initialValue,
    required Function(bool) onChanged,
  }) {
    return GrandPrixBetPositionYesNoItem(
      children: [
        GrandPrixBetLabelCell.build(
          context: context,
          label: label,
        ),
        TableCell(
          verticalAlignment: TableCellVerticalAlignment.middle,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: _ValueCell(
              initialValue: initialValue,
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}

class _ValueCell extends ConsumerWidget {
  final bool? initialValue;
  final Function(bool) onChanged;

  const _ValueCell({this.initialValue, required this.onChanged});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final BetMode betMode = ref.watch(betModeProvider);

    return switch (betMode) {
      BetMode.edit => _YesOrNoSelection(
          initialValue: initialValue,
          onChanged: onChanged,
        ),
      BetMode.preview => _SelectedValue(selectedValue: initialValue),
    };
  }
}

class _SelectedValue extends StatelessWidget {
  final bool? selectedValue;

  const _SelectedValue({required this.selectedValue});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TitleMedium(
        switch (selectedValue) {
          true => context.str.yes,
          false => context.str.no,
          null => '--',
        },
      ),
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
