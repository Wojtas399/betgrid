import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../model/driver.dart';
import '../../../component/gap/gap_horizontal.dart';
import '../../../component/text_component.dart';
import '../../../extensions/build_context_extensions.dart';
import '../cubit/grand_prix_bet_editor_cubit.dart';

class GrandPrixBetEditorDriverField extends StatelessWidget {
  final String? label;
  final Color? labelColor;
  final Function(String)? onDriverSelected;

  const GrandPrixBetEditorDriverField({
    super.key,
    this.label,
    this.labelColor,
    this.onDriverSelected,
  });

  @override
  Widget build(BuildContext context) => Row(
        children: [
          label != null
              ? Expanded(
                  flex: 1,
                  child: TitleMedium(
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
              onDriverSelected: onDriverSelected,
            ),
          ),
        ],
      );
}

class _DriverSelectionFormField extends StatelessWidget {
  final Function(String)? onDriverSelected;

  const _DriverSelectionFormField({
    this.onDriverSelected,
  });

  void _onDriverSelected(String? selectedDriverId) {
    if (onDriverSelected != null && selectedDriverId != null) {
      onDriverSelected!(selectedDriverId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Driver>? allDrivers = context.select(
      (GrandPrixBetEditorCubit cubit) => cubit.state.allDrivers,
    );

    return DropdownButtonFormField<String>(
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
            value: driver.id,
            child: _DriverDescription(driver),
          ),
        ),
      ],
      onChanged: _onDriverSelected,
    );
  }
}

class _DriverDescription extends StatelessWidget {
  final Driver driver;

  const _DriverDescription(this.driver);

  @override
  Widget build(BuildContext context) => Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 4,
            height: 20,
            color: Color(driver.team.hexColor),
          ),
          const GapHorizontal8(),
          BodyMedium(
            '${driver.number}',
            color: context.colorScheme.outline,
          ),
          const GapHorizontal16(),
          BodyMedium(driver.name),
          const GapHorizontal4(),
          BodyMedium(
            driver.surname,
            fontWeight: FontWeight.bold,
          ),
        ],
      );
}
