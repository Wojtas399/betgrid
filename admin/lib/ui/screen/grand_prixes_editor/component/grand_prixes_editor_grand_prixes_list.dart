import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../dependency_injection.dart';
import '../../../../model/grand_prix_basic_info.dart';
import '../../../component/custom_country_flag_component.dart';
import '../../../component/slidable_item.dart';
import '../../../extensions/build_context_extensions.dart';
import '../../../service/dialog_service.dart';
import '../cubit/grand_prixes_editor_cubit.dart';

class GrandPrixesEditorGrandPrixesList extends StatelessWidget {
  const GrandPrixesEditorGrandPrixesList({super.key});

  Future<void> _deleteGrandPrix(
    BuildContext context,
    GrandPrixBasicInfo grandPrix,
  ) async {
    final bool? canDelete = await getIt<DialogService>().askForConfirmation(
      title: context.str.grandPrixesEditorDeleteGrandPrixConfirmationTitle,
      message: context.str.grandPrixesEditorDeleteGrandPrixConfirmationMessage(
        grandPrix.name,
      ),
    );
    if (canDelete == true && context.mounted) {
      context.read<GrandPrixesEditorCubit>().deleteGrandPrix(grandPrix.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final Iterable<GrandPrixBasicInfo> grandPrixes = context.select(
      (GrandPrixesEditorCubit cubit) => cubit.state.grandPrixes!,
    );

    return ListView(
      children:
          ListTile.divideTiles(
            context: context,
            tiles: grandPrixes.map(
              (grandPrix) => _GrandPrixItem(
                grandPrix: grandPrix,
                onDelete: () => _deleteGrandPrix(context, grandPrix),
              ),
            ),
          ).toList(),
    );
  }
}

class _GrandPrixItem extends StatelessWidget {
  final GrandPrixBasicInfo grandPrix;
  final VoidCallback onDelete;

  const _GrandPrixItem({required this.grandPrix, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return SlidableItem(
      onDelete: onDelete,
      child: ListTile(
        title: Text(grandPrix.name),
        leading: CustomCountryFlag(
          countryAlpha2Code: grandPrix.countryAlpha2Code,
        ),
      ),
    );
  }
}
