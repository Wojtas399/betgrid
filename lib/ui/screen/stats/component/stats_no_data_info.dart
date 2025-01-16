import 'package:flutter/material.dart';

import '../../../component/text_component.dart';
import '../../../extensions/build_context_extensions.dart';

class StatsNoDataInfo extends StatelessWidget {
  const StatsNoDataInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: BodyMedium(context.str.statsNoDataTitle),
    );
  }
}
