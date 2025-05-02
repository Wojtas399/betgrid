import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../component/gap/gap_vertical.dart';
import '../../../../extensions/build_context_extensions.dart';
import '../cubit/new_driver_dialog_cubit.dart';
import 'new_driver_dialog_form.dart';

class NewDriverDialogContent extends StatelessWidget {
  const NewDriverDialogContent({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(context.str.driversEditorAddDriver)),
    body: const SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          children: [NewDriverDialogForm(), GapVertical32(), _SubmitButton()],
        ),
      ),
    ),
  );
}

class _SubmitButton extends StatelessWidget {
  const _SubmitButton();

  void _onPressed(BuildContext context) {
    context.read<NewDriverDialogCubit>().submit();
  }

  @override
  Widget build(BuildContext context) => FilledButton(
    onPressed: () => _onPressed(context),
    child: Text(context.str.add),
  );
}
