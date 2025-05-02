import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../component/custom_text_field_component.dart';
import '../../../../component/gap/gap_vertical.dart';
import '../../../../extensions/build_context_extensions.dart';
import '../cubit/new_grand_prix_dialog_cubit.dart';
import '../cubit/new_grand_prix_dialog_state.dart';

class NewGrandPrixDialogForm extends StatelessWidget {
  const NewGrandPrixDialogForm({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [_Name(), GapVertical24(), _CountryAlpha2Code()],
    );
  }
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
        .read<NewGrandPrixDialogCubit>()
        .stream
        .map(
          (NewGrandPrixDialogState state) => (
            cubitStateStatus: state.status,
            isEmpty: state.isGrandPrixNameEmpty,
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
    if (params.cubitStateStatus.hasNewGrandPrixBeenAdded) {
      _controller.clear();
      _focusNode.requestFocus();
    }
  }

  void _onChanged(BuildContext context, String value) {
    context.read<NewGrandPrixDialogCubit>().onGrandPrixNameChanged(value);
  }

  void _onTapOutside(_) {
    _focusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      controller: _controller,
      focusNode: _focusNode,
      label: context.str.grandPrixesEditorGrandPrixName,
      onChanged: (String value) => _onChanged(context, value),
      error: _displayReguiredFieldError ? context.str.requiredFieldInfo : null,
      onTapOutside: _onTapOutside,
    );
  }
}

class _CountryAlpha2Code extends StatefulWidget {
  const _CountryAlpha2Code();

  @override
  State<StatefulWidget> createState() {
    return _CountryAlpha2CodeState();
  }
}

class _CountryAlpha2CodeState extends State<_CountryAlpha2Code> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  StreamSubscription? _cubitParamsListener;
  bool _displayReguiredFieldError = false;

  @override
  void initState() {
    _cubitParamsListener = context
        .read<NewGrandPrixDialogCubit>()
        .stream
        .map(
          (NewGrandPrixDialogState state) => (
            cubitStateStatus: state.status,
            isEmpty: state.isCountryAlpha2CodeEmpty,
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
    if (params.cubitStateStatus.hasNewGrandPrixBeenAdded) {
      _controller.clear();
      _focusNode.requestFocus();
    }
  }

  void _onChanged(BuildContext context, String value) {
    context.read<NewGrandPrixDialogCubit>().onCountryAlpha2CodeChanged(value);
  }

  void _onTapOutside(_) {
    _focusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      controller: _controller,
      focusNode: _focusNode,
      label: context.str.grandPrixesEditorCountryAlpha2Code,
      onChanged: (String value) => _onChanged(context, value),
      error: _displayReguiredFieldError ? context.str.requiredFieldInfo : null,
      onTapOutside: _onTapOutside,
    );
  }
}

typedef _TextFieldListenedParams =
    ({NewGrandPrixDialogStateStatus cubitStateStatus, bool isEmpty});
