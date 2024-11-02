import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../dependency_injection.dart';
import '../../../component/button/big_button.dart';
import '../../../component/gap/gap_vertical.dart';
import '../../../extensions/build_context_extensions.dart';
import '../../../service/dialog_service.dart';
import '../cubit/profile_cubit.dart';
import '../cubit/profile_state.dart';

class ProfileUsernameDialog extends StatefulWidget {
  const ProfileUsernameDialog({super.key});

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<ProfileUsernameDialog> {
  final TextEditingController _textController = TextEditingController();
  String? _originalUsername;
  bool _isUsernameAlreadyTaken = false;
  bool _isSaveButtonDisabled = true;

  @override
  void initState() {
    super.initState();
    _originalUsername = context.read<ProfileCubit>().state.username;
    _textController.text = _originalUsername ?? '';
    _textController.addListener(_checkValueCorrectness);
  }

  @override
  void dispose() {
    _textController.removeListener(_checkValueCorrectness);
    super.dispose();
  }

  void _checkValueCorrectness() {
    final String value = _textController.text;
    setState(() {
      _isSaveButtonDisabled = value.isEmpty || value == _originalUsername;
    });
  }

  String? _validate(BuildContext context) {
    if (_textController.text.isEmpty) return context.str.requiredField;
    if (_isUsernameAlreadyTaken) return context.str.usernameAlreadyTaken;
    return null;
  }

  Future<void> _onSaveButtonPressed() async {
    await context.read<ProfileCubit>().updateUsername(_textController.text);
  }

  void _onProfileStateStatusChanged(ProfileStateStatus status) {
    final dialogService = getIt<DialogService>();
    if (status.isLoading) {
      dialogService.showLoadingDialog();
    } else if (status.isUsernameUpdated) {
      dialogService.closeLoadingDialog();
      context.maybePop();
      dialogService.showSnackbarMessage(
        context.str.profileSuccessfullySavedUsername,
      );
    } else if (status.isNewUsernameAlreadyTaken) {
      dialogService.closeLoadingDialog();
      setState(() {
        _isUsernameAlreadyTaken = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) =>
      BlocListener<ProfileCubit, ProfileState>(
        listenWhen: (prevState, currState) =>
            prevState.status != currState.status,
        listener: (_, ProfileState state) =>
            _onProfileStateStatusChanged(state.status),
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: context.maybePop,
              icon: const Icon(Icons.close),
            ),
            title: Text(context.str.profileNewUsernameDialogTitle),
          ),
          body: SafeArea(
            child: Container(
              padding: const EdgeInsets.all(24),
              color: Colors.transparent,
              child: Column(
                children: [
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: context.str.usernameHintText,
                    ),
                    controller: _textController,
                    validator: (_) => _validate(context),
                    autovalidateMode: AutovalidateMode.always,
                    onTapOutside: (_) {
                      FocusScope.of(context).unfocus();
                    },
                    onChanged: (_) {
                      setState(() {
                        _isUsernameAlreadyTaken = false;
                      });
                    },
                  ),
                  const GapVertical40(),
                  BigButton(
                    label: context.str.save,
                    onPressed:
                        _isSaveButtonDisabled ? null : _onSaveButtonPressed,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}
