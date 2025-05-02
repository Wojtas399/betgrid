import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../component/gap/gap_vertical.dart';
import '../../../../extensions/build_context_extensions.dart';
import '../cubit/new_grand_prix_dialog_cubit.dart';
import 'new_grand_prix_dialog_form.dart';

class NewGrandPrixDialogContent extends StatelessWidget {
  const NewGrandPrixDialogContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.str.grandPrixesEditorAddGrandPrix)),
      body: const SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            children: [
              NewGrandPrixDialogForm(),
              GapVertical32(),
              _SubmitButton(),
            ],
          ),
        ),
      ),
    );
  }
}

class _SubmitButton extends StatelessWidget {
  const _SubmitButton();

  void _onPressed(BuildContext context) {
    context.read<NewGrandPrixDialogCubit>().addNewGrandPrix();
  }

  @override
  Widget build(BuildContext context) => FilledButton(
    onPressed: () => _onPressed(context),
    child: Text(context.str.add),
  );
}
