import 'package:flutter/material.dart';

class _CustomPadding extends StatelessWidget {
  final double value;
  final Widget child;

  const _CustomPadding(this.value, {required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(padding: EdgeInsets.all(value), child: child);
  }
}

class Padding8 extends _CustomPadding {
  const Padding8({required super.child}) : super(8);
}

class Padding16 extends _CustomPadding {
  const Padding16({required super.child}) : super(16);
}

class Padding24 extends _CustomPadding {
  const Padding24({required super.child}) : super(24);
}
