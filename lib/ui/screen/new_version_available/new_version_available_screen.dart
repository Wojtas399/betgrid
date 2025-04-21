import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class NewVersionAvailableScreen extends StatelessWidget {
  const NewVersionAvailableScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Material(child: Center(child: Text('New version available')));
  }
}
