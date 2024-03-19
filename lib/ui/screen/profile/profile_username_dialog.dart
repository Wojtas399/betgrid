import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../component/button/big_button.dart';
import '../../component/gap/gap_vertical.dart';
import '../../controller/logged_user/logged_user_controller.dart';
import '../../controller/logged_user/logged_user_controller_state.dart';
import '../../extensions/build_context_extensions.dart';
import '../../provider/logged_user_provider.dart';
import '../../service/dialog_service.dart';

class ProfileUsernameDialog extends ConsumerStatefulWidget {
  const ProfileUsernameDialog({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _State();
  }
}

class _State extends ConsumerState<ProfileUsernameDialog> {
  final TextEditingController _textController = TextEditingController();
  String? _originalUsername;
  bool _isUsernameAlreadyTaken = false;
  bool _isSaveButtonDisabled = true;

  @override
  void initState() {
    super.initState();
    _originalUsername = ref.read(
      loggedUserProvider.select(
        (loggedUserData) => loggedUserData.value?.username,
      ),
    );
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
    await ref
        .read(loggedUserControllerProvider.notifier)
        .updateUsername(_textController.text);
  }

  void _onLoggedUserControllerStateChanged(
    AsyncValue<LoggedUserControllerState> controllerState,
  ) {
    controllerState.when(
      data: (state) {
        if (state is LoggedUserControllerStateUsernameUpdated) {
          closeLoadingDialog();
          context.popRoute();
          showSnackbarMessage(context.str.profileSuccessfullySavedUsername);
        }
      },
      error: (error, _) {
        if (error is LoggedUserControllerStateNewUsernameIsAlreadyTaken) {
          closeLoadingDialog();
          setState(() {
            _isUsernameAlreadyTaken = true;
          });
        }
      },
      loading: () => showLoadingDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(
      loggedUserControllerProvider,
      (_, next) => _onLoggedUserControllerStateChanged(next),
    );

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: context.popRoute,
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
                onPressed: _isSaveButtonDisabled ? null : _onSaveButtonPressed,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
