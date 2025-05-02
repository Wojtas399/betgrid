import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../component/gap/gap_vertical.dart';
import '../../../../component/padding_component.dart';
import '../../../../extensions/build_context_extensions.dart';
import '../cubit/new_team_dialog_cubit.dart';
import 'new_team_dialog_form.dart';

class NewTeamDialogContent extends StatelessWidget {
  const NewTeamDialogContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.str.teamsEditorAddTeam)),
      body: const SingleChildScrollView(
        child: Padding24(
          child: Column(
            children: [NewTeamDialogForm(), GapVertical32(), _SubmitButton()],
          ),
        ),
      ),
    );
  }
}

class _SubmitButton extends StatelessWidget {
  const _SubmitButton();

  void _onPressed(BuildContext context) {
    context.read<NewTeamDialogCubit>().submit();
  }

  @override
  Widget build(BuildContext context) => FilledButton(
    onPressed: () => _onPressed(context),
    child: Text(context.str.add),
  );
}
