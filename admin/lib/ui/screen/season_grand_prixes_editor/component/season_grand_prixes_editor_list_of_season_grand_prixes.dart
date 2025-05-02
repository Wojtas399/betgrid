import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../dependency_injection.dart';
import '../../../../model/season_grand_prix_details.dart';
import '../../../component/season_grand_prix_item_component.dart';
import '../../../component/slidable_item.dart';
import '../../../extensions/build_context_extensions.dart';
import '../../../extensions/widget_list_extensions.dart';
import '../../../service/dialog_service.dart';
import '../cubit/season_grand_prixes_editor_cubit.dart';

class SeasonGrandPrixesEditorListOfSeasonGrandPrixes extends StatelessWidget {
  const SeasonGrandPrixesEditorListOfSeasonGrandPrixes({super.key});

  Future<void> _onDeleteGrandPrix(
    String seasonGrandPrixId,
    String grandPrixName,
    BuildContext context,
  ) async {
    final cubit = context.read<SeasonGrandPrixesEditorCubit>();
    final bool? canDelete = await getIt<DialogService>().askForConfirmation(
      title:
          context
              .str
              .seasonGrandPrixesEditorSeasonGrandPrixDeletionConfirmationTitle,
      message: context.str
          .seasonGrandPrixesEditorSeasonGrandPrixDeletionConfirmationMessage(
            grandPrixName,
            cubit.state.selectedSeason!,
          ),
    );
    if (canDelete == true) {
      cubit.deleteGrandPrixFromSeason(seasonGrandPrixId: seasonGrandPrixId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<SeasonGrandPrixDetails>? grandPrixesFromSeason = context.select(
      (SeasonGrandPrixesEditorCubit cubit) => cubit.state.grandPrixesInSeason,
    );

    return grandPrixesFromSeason != null
        ? Column(
          children: [
            ...grandPrixesFromSeason.map(
              (grandPrix) => SlidableItem(
                onDelete:
                    () => _onDeleteGrandPrix(
                      grandPrix.seasonGrandPrixId,
                      grandPrix.grandPrixName,
                      context,
                    ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 16,
                  ),
                  child: SeasonGrandPrixItem(seasonGrandPrixDetails: grandPrix),
                ),
              ),
            ),
          ].divide(const Divider(height: 0)),
        )
        : const Center(child: CircularProgressIndicator());
  }
}
