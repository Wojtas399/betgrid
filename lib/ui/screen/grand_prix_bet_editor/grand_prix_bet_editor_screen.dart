import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import 'component/grand_prix_bet_editor_content.dart';

@RoutePage()
class GrandPrixBetEditorScreen extends StatelessWidget {
  const GrandPrixBetEditorScreen({super.key});

  @override
  Widget build(BuildContext context) => const GrandPrixBetEditorContent();
}
