import 'package:flutter/material.dart';

import '../extensions/build_context_extensions.dart';
import 'text_component.dart';

class NoText extends StatelessWidget {
  const NoText({super.key});

  @override
  Widget build(BuildContext context) {
    return BodyMedium(context.str.doubleDash);
  }
}
