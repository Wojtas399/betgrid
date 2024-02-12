import 'package:flutter/material.dart';

class GapVertical extends StatelessWidget {
  final double gap;

  const GapVertical(this.gap, {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: gap);
  }
}

class GapVertical4 extends GapVertical {
  const GapVertical4({super.key}) : super(4);
}

class GapVertical16 extends GapVertical {
  const GapVertical16({super.key}) : super(16);
}

class GapVertical32 extends GapVertical {
  const GapVertical32({super.key}) : super(32);
}

class GapVertical64 extends GapVertical {
  const GapVertical64({super.key}) : super(64);
}
