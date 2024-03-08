import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../model/driver.dart';
import '../../component/gap/gap_horizontal.dart';
import '../../component/gap/gap_vertical.dart';
import '../../component/text/body.dart';
import '../../component/text/label.dart';
import '../../component/text/title.dart';
import '../../provider/driver_provider.dart';
import 'grand_prix_bet_label_cell.dart';

class GrandPrixBetPositionItem extends TableRow {
  const GrandPrixBetPositionItem({super.key, super.children});

  factory GrandPrixBetPositionItem.build({
    required BuildContext context,
    required String label,
    Color? labelBackgroundColor,
    String? betDriverId,
    String? resultsDriverId,
    int? points,
  }) {
    return GrandPrixBetPositionItem(
      children: [
        GrandPrixBetLabelCell.build(
          context: context,
          label: label,
          labelBackgroundColor: labelBackgroundColor,
        ),
        _BetInfo.build(
          context: context,
          betDriverId: betDriverId,
          resultsDriverId: resultsDriverId,
        ),
        BetPoints.build(context: context, points: points),
      ],
    );
  }
}

class _BetInfo extends TableCell {
  const _BetInfo({required super.child})
      : super(verticalAlignment: TableCellVerticalAlignment.middle);

  factory _BetInfo.build({
    required BuildContext context,
    String? betDriverId,
    String? resultsDriverId,
  }) =>
      _BetInfo(
        child: Column(
          children: [
            const GapVertical8(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: [
                  SizedBox(
                    width: 48,
                    child: Text(
                      'Typ: ',
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                  ),
                  const GapHorizontal8(),
                  DriverDescription(driverId: betDriverId),
                ],
              ),
            ),
            const Divider(thickness: 0.25),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: [
                  SizedBox(
                    width: 48,
                    child: Text(
                      'Wynik: ',
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                  ),
                  const GapHorizontal8(),
                  DriverDescription(driverId: resultsDriverId),
                ],
              ),
            ),
            const GapVertical8(),
          ],
        ),
      );
}

class BetPoints extends TableCell {
  const BetPoints({super.key, required super.child})
      : super(verticalAlignment: TableCellVerticalAlignment.middle);

  factory BetPoints.build({
    required BuildContext context,
    int? points,
  }) =>
      BetPoints(
        child: Column(
          children: [
            LabelLarge(
              'Punkty',
              color: Theme.of(context).colorScheme.outline,
            ),
            const GapVertical4(),
            TitleMedium(
              points?.toString() ?? '--',
              fontWeight: FontWeight.bold,
            ),
          ],
        ),
      );
}

class DriverDescription extends ConsumerWidget {
  final String? driverId;

  const DriverDescription({super.key, required this.driverId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Driver? driver;
    if (driverId != null) {
      driver = ref.watch(driverProvider(driverId: driverId!)).value;
    }

    return driver != null
        ? Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 8,
                height: 20,
                color: Color(driver.team.hexColor),
              ),
              const GapHorizontal4(),
              SizedBox(
                width: 25,
                child: BodyMedium(
                  '${driver.number}',
                  textAlign: TextAlign.center,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const GapHorizontal4(),
              TitleMedium('${driver.name} ${driver.surname}'),
            ],
          )
        : const Center(
            child: TitleMedium(
              '--',
              fontWeight: FontWeight.bold,
            ),
          );
  }
}
