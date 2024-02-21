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

class GapVertical8 extends GapVertical {
  const GapVertical8({super.key}) : super(8);
}

class GapVertical16 extends GapVertical {
  const GapVertical16({super.key}) : super(16);
}

class GapVertical24 extends GapVertical {
  const GapVertical24({super.key}) : super(24);
}

class GapVertical32 extends GapVertical {
  const GapVertical32({super.key}) : super(32);
}

class GapVertical40 extends GapVertical {
  const GapVertical40({super.key}) : super(40);
}

class GapVertical64 extends GapVertical {
  const GapVertical64({super.key}) : super(64);
}
