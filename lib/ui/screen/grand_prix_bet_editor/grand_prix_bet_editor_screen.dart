import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class GrandPrixBetEditorScreen extends StatelessWidget {
  const GrandPrixBetEditorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edytor grand prix betu'),
      ),
    );
  }
}
