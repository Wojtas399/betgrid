import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../component/gap/gap_vertical.dart';
import '../../../component/text_component.dart';
import '../../../extensions/build_context_extensions.dart';
import '../cubit/required_data_completion_cubit.dart';
import '../cubit/required_data_completion_state.dart';

class RequiredDataCompletionUsername extends StatefulWidget {
  const RequiredDataCompletionUsername({super.key});

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<RequiredDataCompletionUsername> {
  bool _canValidateTextField = false;
  bool _isUsernameEmpty = false;
  bool _isUsernameAlreadyTaken = false;

  void _onTextFieldChanged(String username) {
    setState(() {
      _isUsernameAlreadyTaken = false;
      _isUsernameEmpty = false;
      _canValidateTextField = false;
    });
    context.read<RequiredDataCompletionCubit>().updateUsername(username);
  }

  String? _validate(BuildContext context) {
    if (!_canValidateTextField) return null;
    if (_isUsernameEmpty) return context.str.requiredField;
    if (_isUsernameAlreadyTaken) return context.str.usernameAlreadyTaken;
    return null;
  }

  void _onCubitStatusChanged(RequiredDataCompletionStateStatus status) {
    if (status.isUsernameAlreadyTaken) {
      setState(() {
        _isUsernameAlreadyTaken = true;
        _canValidateTextField = true;
      });
    } else if (status.isUsernameEmpty) {
      setState(() {
        _isUsernameEmpty = true;
        _canValidateTextField = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) =>
      BlocListener<RequiredDataCompletionCubit, RequiredDataCompletionState>(
        listenWhen: (prevState, currState) =>
            prevState.status != currState.status,
        listener: (_, RequiredDataCompletionState state) =>
            _onCubitStatusChanged(state.status),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TitleLarge(context.str.username),
              const GapVertical16(),
              TextFormField(
                decoration:
                    InputDecoration(hintText: context.str.usernameHintText),
                onChanged: _onTextFieldChanged,
                validator: (_) => _validate(context),
                autovalidateMode: AutovalidateMode.always,
                onTapOutside: (_) {
                  FocusScope.of(context).unfocus();
                },
              ),
            ],
          ),
        ),
      );
}
