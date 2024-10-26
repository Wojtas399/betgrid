import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../dependency_injection.dart';
import 'component/grand_prix_bet_editor_content.dart';
import 'cubit/grand_prix_bet_editor_cubit.dart';

@RoutePage()
class GrandPrixBetEditorScreen extends StatelessWidget {
  final String grandPrixId;

  const GrandPrixBetEditorScreen({
    super.key,
    required this.grandPrixId,
  });

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (_) => getIt.get<GrandPrixBetEditorCubit>()
          ..initialize(
            grandPrixId: grandPrixId,
          ),
        child: const GrandPrixBetEditorContent(),
      );
}
