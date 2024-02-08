import 'package:flutter/material.dart';

class GapHorizontal extends StatelessWidget {
  final double gap;

  const GapHorizontal(this.gap, {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: gap);
  }
}

class GapHorizontal8 extends GapHorizontal {
  const GapHorizontal8({super.key}) : super(8);
}

class GapHorizontal16 extends GapHorizontal {
  const GapHorizontal16({super.key}) : super(16);
}