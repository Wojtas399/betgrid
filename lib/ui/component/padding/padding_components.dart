import 'package:flutter/material.dart';

abstract class CustomPadding extends StatelessWidget {
  final double padding;
  final Widget child;

  const CustomPadding({super.key, required this.padding, required this.child});

  @override
  Widget build(BuildContext context) =>
      Padding(padding: EdgeInsets.all(padding), child: child);
}

class Padding24 extends CustomPadding {
  const Padding24({super.key, required super.child}) : super(padding: 24);
}

class Padding16 extends CustomPadding {
  const Padding16({super.key, required super.child}) : super(padding: 16);
}

class Padding8 extends CustomPadding {
  const Padding8({super.key, required super.child}) : super(padding: 8);
}
