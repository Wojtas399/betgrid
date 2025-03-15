import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../model/driver_details.dart';
import '../../../../component/driver_description_component.dart';
import '../../../../component/text_component.dart';
import '../../../../extensions/build_context_extensions.dart';
import '../../../../extensions/string_extensions.dart';
import '../cubit/season_grand_prix_bet_editor_cubit.dart';

class SeasonGrandPrixBetEditorDriverField extends StatelessWidget {
  final String? label;
  final Color? labelColor;
  final String? selectedSeasonDriverId;
  final List<String>? allSelectedSeasonDriverIds;
  final Function(String)? onSeasonDriverSelected;

  const SeasonGrandPrixBetEditorDriverField({
    super.key,
    this.label,
    this.labelColor,
    this.selectedSeasonDriverId,
    this.allSelectedSeasonDriverIds,
    this.onSeasonDriverSelected,
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
          : const SizedBox(width: 8),
      Expanded(
        flex: 5,
        child: _DriverSelectionFormField(
          selectedSeasonDriverId: selectedSeasonDriverId,
          allSelectedSeasonDriverIds: allSelectedSeasonDriverIds,
          onSeasonDriverSelected: onSeasonDriverSelected,
        ),
      ),
    ],
  );
}

class _DriverSelectionFormField extends StatelessWidget {
  final String? selectedSeasonDriverId;
  final List<String>? allSelectedSeasonDriverIds;
  final Function(String)? onSeasonDriverSelected;

  const _DriverSelectionFormField({
    this.selectedSeasonDriverId,
    this.allSelectedSeasonDriverIds,
    this.onSeasonDriverSelected,
  });

  void _onSeasonDriverSelected(String? selectedSeasonDriverId) {
    if (onSeasonDriverSelected != null && selectedSeasonDriverId != null) {
      onSeasonDriverSelected!(selectedSeasonDriverId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<DriverDetails>? allDriversDetails = context.select(
      (SeasonGrandPrixBetEditorCubit cubit) => cubit.state.allDrivers,
    );

    return DropdownButtonFormField<String>(
      value: selectedSeasonDriverId,
      decoration: InputDecoration(
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        errorBorder: InputBorder.none,
        disabledBorder: InputBorder.none,
        fillColor: context.colorScheme.surfaceContainer,
      ),
      hint: Align(
        alignment: Alignment.centerLeft,
        child: Text(context.str.seasonGrandPrixBetEditorSelectDriver),
      ),
      items: [
        ...?allDriversDetails?.map((DriverDetails driverDetails) {
          final bool isAlreadySelectedInOtherField =
              allSelectedSeasonDriverIds?.contains(
                driverDetails.seasonDriverId,
              ) ==
              true;

          return DropdownMenuItem(
            value: driverDetails.seasonDriverId,
            child: Container(
              color:
                  driverDetails.seasonDriverId == selectedSeasonDriverId
                      ? context.colorScheme.primaryContainer
                      : null,
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  DriverDescription(
                    name: driverDetails.name,
                    surname: driverDetails.surname,
                    number: driverDetails.number,
                    teamColor: driverDetails.teamHexColor.toColor(),
                  ),
                  if (isAlreadySelectedInOtherField &&
                      driverDetails.seasonDriverId != selectedSeasonDriverId)
                    Icon(
                      Icons.check,
                      color: context.colorScheme.outline,
                      size: 20,
                    ),
                ],
              ),
            ),
          );
        }),
      ],
      selectedItemBuilder:
          (_) => [
            ...?allDriversDetails?.map(
              (DriverDetails driverDetails) => DriverDescription(
                name: driverDetails.name,
                surname: driverDetails.surname,
                number: driverDetails.number,
                teamColor: driverDetails.teamHexColor.toColor(),
              ),
            ),
          ],
      onChanged: _onSeasonDriverSelected,
    );
  }
}
