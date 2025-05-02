import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../component/custom_text_field_component.dart';
import '../../../../component/gap/gap_vertical.dart';
import '../../../../extensions/build_context_extensions.dart';
import '../cubit/new_team_dialog_cubit.dart';
import '../cubit/new_team_dialog_state.dart';

class NewTeamDialogForm extends StatelessWidget {
  const NewTeamDialogForm({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(children: [_Name(), GapVertical24(), _HexColor()]);
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
        .read<NewTeamDialogCubit>()
        .stream
        .map(
          (NewTeamDialogState state) => (
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
    if (params.cubitStateStatus.hasNewTeamBasicInfoBeenAdded) {
      _controller.clear();
      _focusNode.requestFocus();
    }
  }

  void _onChanged(BuildContext context, String value) {
    context.read<NewTeamDialogCubit>().onNameChanged(value);
  }

  void _onTapOutside(_) {
    _focusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      controller: _controller,
      focusNode: _focusNode,
      label: context.str.teamsEditorTeamName,
      onChanged: (String value) => _onChanged(context, value),
      error: _displayReguiredFieldError ? context.str.requiredFieldInfo : null,
      onTapOutside: _onTapOutside,
    );
  }
}

class _HexColor extends StatefulWidget {
  const _HexColor();

  @override
  State<StatefulWidget> createState() {
    return _HexColorState();
  }
}

class _HexColorState extends State<_HexColor> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  StreamSubscription? _cubitParamsListener;
  bool _displayReguiredFieldError = false;

  @override
  void initState() {
    _cubitParamsListener = context
        .read<NewTeamDialogCubit>()
        .stream
        .map(
          (NewTeamDialogState state) => (
            cubitStateStatus: state.status,
            isEmpty: state.isHexColorEmpty,
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
    if (params.cubitStateStatus.hasNewTeamBasicInfoBeenAdded) {
      _controller.clear();
    }
  }

  void _onChanged(BuildContext context, String value) {
    context.read<NewTeamDialogCubit>().onHexColorChanged(value);
  }

  void _onTapOutside(_) {
    _focusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      controller: _controller,
      focusNode: _focusNode,
      label: context.str.teamsEditorTeamHexColor,
      onChanged: (String value) => _onChanged(context, value),
      error: _displayReguiredFieldError ? context.str.requiredFieldInfo : null,
      onTapOutside: _onTapOutside,
    );
  }
}

typedef _TextFieldListenedParams =
    ({NewTeamDialogStateStatus cubitStateStatus, bool isEmpty});
