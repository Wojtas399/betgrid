import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import 'component/new_version_available_content.dart';

@RoutePage()
class NewVersionAvailableScreen extends StatelessWidget {
  const NewVersionAvailableScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const NewVersionAvailableContent();
  }
}
