import 'package:flutter/material.dart';

class GrandPrixBetTable extends StatelessWidget {
  final List<TableRow> rows;

  const GrandPrixBetTable({super.key, required this.rows});

  @override
  Widget build(BuildContext context) {
    return Table(
      border: TableBorder(
        horizontalInside: BorderSide(
          width: 0.25,
          color: Theme.of(context).colorScheme.outline.withOpacity(0.5),
        ),
        verticalInside: BorderSide(
          width: 0.25,
          color: Theme.of(context).colorScheme.outline.withOpacity(0.5),
        ),
      ),
      columnWidths: const <int, TableColumnWidth>{
        0: FixedColumnWidth(51),
        1: FlexColumnWidth(),
        2: FixedColumnWidth(70),
      },
      children: rows,
    );
  }
}
