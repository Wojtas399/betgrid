import 'package:flutter/material.dart';

import '../../../component/slidable_item.dart';
import '../../../component/text_component.dart';
import '../cubit/season_drivers_editor_state.dart';

class SeasonDriversEditorDriverItem extends StatelessWidget {
  final SeasonDriverDescription driverDescription;
  final VoidCallback onDelete;

  const SeasonDriversEditorDriverItem({
    super.key,
    required this.driverDescription,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return SlidableItem(
      onDelete: onDelete,
      child: ListTile(
        title: Text('${driverDescription.name} ${driverDescription.surname}'),
        subtitle: Text(driverDescription.teamNameInSeason),
        leading: SizedBox(
          width: 30,
          child: Center(
            child: TitleMedium('${driverDescription.numberInSeason}'),
          ),
        ),
      ),
    );
  }
}
