import 'package:flutter/material.dart';

import '../../../component/gap/gap_vertical.dart';
import '../../../component/padding/padding_components.dart';
import '../../../component/text_component.dart';
import '../../../extensions/build_context_extensions.dart';

class BetsNoBetsInfo extends StatelessWidget {
  const BetsNoBetsInfo({super.key});

  @override
  Widget build(BuildContext context) => Padding24(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TitleLarge(
                context.str.betsNoBetsTitle,
                fontWeight: FontWeight.bold,
              ),
              const GapVertical16(),
              BodyMedium(
                context.str.betsNoBetsMessage,
                textAlign: TextAlign.center,
                color: context.colorScheme.outline,
              ),
            ],
          ),
        ),
      );
}
