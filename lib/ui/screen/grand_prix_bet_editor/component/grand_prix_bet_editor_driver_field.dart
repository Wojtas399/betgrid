import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../model/driver_details.dart';
import '../../../component/driver_description_component.dart';
import '../../../component/text_component.dart';
import '../../../extensions/build_context_extensions.dart';
import '../../../extensions/string_extensions.dart';
import '../cubit/grand_prix_bet_editor_cubit.dart';

class GrandPrixBetEditorDriverField extends StatelessWidget {
  final String? label;
  final Color? labelColor;
  final String? selectedDriverId;
  final Function(String)? onDriverSelected;

  const GrandPrixBetEditorDriverField({
    super.key,
    this.label,
    this.labelColor,
    this.selectedDriverId,
    this.onDriverSelected,
  });

  @override
  Widget build(BuildContext context) => Row(
        children: [
          label != null
              ? Expanded(
                  flex: 1,
                  child: LabelLarge(
                    label!,
                    textAlign: TextAlign.center,
                    fontWeight: FontWeight.bold,
                    color: labelColor,
                  ),
                )
              : const SizedBox(
                  width: 8,
                ),
          Expanded(
            flex: 5,
            child: _DriverSelectionFormField(
              selectedDriverId: selectedDriverId,
              onDriverSelected: onDriverSelected,
            ),
          ),
        ],
      );
}

class _DriverSelectionFormField extends StatelessWidget {
  final String? selectedDriverId;
  final Function(String)? onDriverSelected;

  const _DriverSelectionFormField({
    this.selectedDriverId,
    this.onDriverSelected,
  });

  void _onDriverSelected(String? selectedDriverId) {
    if (onDriverSelected != null && selectedDriverId != null) {
      onDriverSelected!(selectedDriverId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<DriverDetails>? allDrivers = context.select(
      (GrandPrixBetEditorCubit cubit) => cubit.state.allDrivers,
    );

    return DropdownButtonFormField<String>(
      value: selectedDriverId,
      decoration: InputDecoration(
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        errorBorder: InputBorder.none,
        disabledBorder: InputBorder.none,
        fillColor: context.colorScheme.surfaceContainer,
      ),
      hint: Align(
        alignment: Alignment.centerLeft,
        child: Text(context.str.grandPrixBetEditorSelectDriver),
      ),
      items: [
        ...?allDrivers?.map(
          (driver) => DropdownMenuItem(
            value: driver.seasonDriverId,
            child: DriverDescription(
              name: driver.name,
              surname: driver.surname,
              number: driver.number,
              teamColor: driver.teamHexColor.toColor(),
            ),
          ),
        ),
      ],
      onChanged: _onDriverSelected,
    );
  }
}
