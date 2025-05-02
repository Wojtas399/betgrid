import 'package:flutter/material.dart';

import '../../../../model/team_basic_info.dart';
import '../../../component/slidable_item.dart';
import '../../../extensions/string_extensions.dart';

class SeasonTeamsCreatorTeamItem extends StatelessWidget {
  final TeamBasicInfo teamBasicInfo;
  final VoidCallback onDelete;

  const SeasonTeamsCreatorTeamItem({
    super.key,
    required this.teamBasicInfo,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return SlidableItem(
      onDelete: onDelete,
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: teamBasicInfo.hexColor.toColor(),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        title: Text(teamBasicInfo.name),
      ),
    );
  }
}
