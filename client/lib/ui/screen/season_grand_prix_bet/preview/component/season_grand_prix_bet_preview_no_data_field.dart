import 'package:flutter/material.dart';

import '../../../../component/text_component.dart';
import '../../../../extensions/build_context_extensions.dart';

class GrandPrixBetNoDataField extends StatelessWidget {
  const GrandPrixBetNoDataField({super.key});

  @override
  Widget build(BuildContext context) => BodyMedium(context.str.doubleDash);
}
