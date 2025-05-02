import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../component/custom_text_field_component.dart';
import '../../../../component/gap/gap_vertical.dart';
import '../../../../extensions/build_context_extensions.dart';
import '../cubit/new_driver_dialog_cubit.dart';
import '../cubit/new_driver_dialog_state.dart';

class NewDriverDialogForm extends StatelessWidget {
  const NewDriverDialogForm({super.key});

  @override
  Widget build(BuildContext context) =>
      const Column(children: [_Name(), GapVertical24(), _Surname()]);
}

class _Name extends StatefulWidget {
  const _Name();

  @override
  State<StatefulWidget> createState() {
    return _NameState();
  }
}

class _NameState extends State<_Name> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  StreamSubscription? _cubitParamsListener;
  bool _displayReguiredFieldError = false;

  @override
  void initState() {
    _cubitParamsListener = context
        .read<NewDriverDialogCubit>()
        .stream
        .map(
          (NewDriverDialogState state) => (
            cubitStateStatus: state.status,
            isEmpty: state.isNameEmpty,
          ),
        )
        .listen(_manageListenedParams);
    super.initState();
  }

  @override
  void dispose() {
    _cubitParamsListener?.cancel();
    super.dispose();
  }

  void _manageListenedParams(_TextFieldListenedParams params) {
    setState(() {
      _displayReguiredFieldError =
          params.cubitStateStatus.isFormNotCompleted && params.isEmpty;
    });
    if (params.cubitStateStatus.hasNewDriverPersonalDataBeenAdded) {
      _controller.clear();
      _focusNode.requestFocus();
    }
  }

  void _onChanged(BuildContext context, String value) {
    context.read<NewDriverDialogCubit>().onNameChanged(value);
  }

  void _onTapOutside(_) {
    _focusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      controller: _controller,
      focusNode: _focusNode,
      label: context.str.driverPersonalDataName,
      onChanged: (String value) => _onChanged(context, value),
      error: _displayReguiredFieldError ? context.str.requiredFieldInfo : null,
      onTapOutside: _onTapOutside,
    );
  }
}

class _Surname extends StatefulWidget {
  const _Surname();

  @override
  State<StatefulWidget> createState() {
    return _SurnameState();
  }
}

class _SurnameState extends State<_Surname> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  StreamSubscription? _cubitParamsListener;
  bool _displayReguiredFieldError = false;

  @override
  void initState() {
    _cubitParamsListener = context
        .read<NewDriverDialogCubit>()
        .stream
        .map(
          (NewDriverDialogState state) => (
            cubitStateStatus: state.status,
            isEmpty: state.isSurnameEmpty,
          ),
        )
        .listen(_manageListenedParams);
    super.initState();
  }

  @override
  void dispose() {
    _cubitParamsListener?.cancel();
    super.dispose();
  }

  void _manageListenedParams(_TextFieldListenedParams params) {
    setState(() {
      _displayReguiredFieldError =
          params.cubitStateStatus.isFormNotCompleted && params.isEmpty;
    });
    if (params.cubitStateStatus.hasNewDriverPersonalDataBeenAdded) {
      _controller.clear();
    }
  }

  void _onChanged(BuildContext context, String value) {
    context.read<NewDriverDialogCubit>().onSurnameChanged(value);
  }

  void _onTapOutside(_) {
    _focusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      controller: _controller,
      focusNode: _focusNode,
      label: context.str.driverPersonalDataSurname,
      onChanged: (String value) => _onChanged(context, value),
      error: _displayReguiredFieldError ? context.str.requiredFieldInfo : null,
      onTapOutside: _onTapOutside,
    );
  }
}

typedef _TextFieldListenedParams =
    ({NewDriverDialogStateStatus cubitStateStatus, bool isEmpty});
