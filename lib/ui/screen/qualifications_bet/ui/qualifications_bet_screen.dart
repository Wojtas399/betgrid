import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../../extensions/build_context_extensions.dart';

@RoutePage()
class QualificationsBetScreen extends StatelessWidget {
  const QualificationsBetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.str.qualifications),
      ),
      body: const Center(
        child: Text('Hello!'),
      ),
    );
  }
}
