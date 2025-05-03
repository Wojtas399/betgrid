import 'package:flutter/material.dart';

import '../../../../model/season_team.dart';
import '../../../component/slidable_item.dart';
import '../../../extensions/string_extensions.dart';

class SeasonTeamsCreatorTeamItem extends StatelessWidget {
  final SeasonTeam team;
  final VoidCallback onDelete;

  const SeasonTeamsCreatorTeamItem({
    super.key,
    required this.team,
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
            color: team.baseHexColor.toColor(),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        title: Text(team.shortName),
      ),
    );
  }
}
