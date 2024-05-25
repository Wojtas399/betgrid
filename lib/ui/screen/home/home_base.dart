import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class HomeBaseScreen extends StatelessWidget {
  const HomeBaseScreen({super.key});

  @override
  Widget build(BuildContext context) => const AutoRouter();
}
