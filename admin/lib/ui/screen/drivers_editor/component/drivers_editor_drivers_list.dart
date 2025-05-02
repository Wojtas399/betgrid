import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../dependency_injection.dart';
import '../../../../model/driver_personal_data.dart';
import '../../../component/slidable_item.dart';
import '../../../component/text_component.dart';
import '../../../extensions/build_context_extensions.dart';
import '../../../service/dialog_service.dart';
import '../cubit/drivers_editor_cubit.dart';

class DriversEditorDriversList extends StatelessWidget {
  const DriversEditorDriversList({super.key});

  Future<void> _deleteDriver(
    BuildContext context,
    DriverPersonalData driver,
  ) async {
    final bool? canDelete = await getIt<DialogService>().askForConfirmation(
      title: context.str.driversEditorDeleteDriverConfirmationTitle,
      message: context.str.driversEditorDeleteDriverConfirmationMessage(
        '${driver.name} ${driver.surname}',
      ),
    );
    if (canDelete == true && context.mounted) {
      context.read<DriversEditorCubit>().deleteDriverPersonalData(driver.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<DriverPersonalData> drivers = context.select(
      (DriversEditorCubit cubit) => cubit.state.drivers!,
    );

    return ListView(
      children:
          ListTile.divideTiles(
            context: context,
            tiles: drivers.map(
              (driver) => _DriverItem(
                driver: driver,
                onDelete: () => _deleteDriver(context, driver),
              ),
            ),
          ).toList(),
    );
  }
}

class _DriverItem extends StatelessWidget {
  const _DriverItem({required this.driver, required this.onDelete});

  final DriverPersonalData driver;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) => SlidableItem(
    onDelete: onDelete,
    child: ListTile(
      title: Row(
        spacing: 4.0,
        children: [
          Text(driver.name),
          TitleMedium(driver.surname, fontWeight: FontWeight.bold),
        ],
      ),
    ),
  );
}
