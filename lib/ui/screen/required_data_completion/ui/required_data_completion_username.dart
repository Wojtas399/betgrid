import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../component/gap/gap_vertical.dart';
import '../../../component/text/title.dart';
import '../../../controller/logged_user/logged_user_controller.dart';
import '../../../controller/logged_user/logged_user_controller_state.dart';
import '../../../extensions/build_context_extensions.dart';
import '../controller/required_data_completion_controller.dart';

class RequiredDataCompletionUsername extends ConsumerStatefulWidget {
  const RequiredDataCompletionUsername({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _State();
}

class _State extends ConsumerState<RequiredDataCompletionUsername> {
  bool _canValidateTextField = false;
  bool _isUsernameEmpty = false;
  bool _isUsernameAlreadyTaken = false;

  void _onTextFieldChanged(String username, WidgetRef ref) {
    setState(() {
      _isUsernameAlreadyTaken = false;
      _isUsernameEmpty = false;
      _canValidateTextField = false;
    });
    ref
        .read(requiredDataCompletionControllerProvider.notifier)
        .updateUsername(username);
  }

  String? _validate(BuildContext context) {
    if (!_canValidateTextField) return null;
    if (_isUsernameEmpty) return context.str.requiredField;
    if (_isUsernameAlreadyTaken) return context.str.usernameAlreadyTaken;
    return null;
  }

  void _onLoggedUserControllerStateChanged(
    AsyncValue<void> asyncValue,
    BuildContext context,
  ) {
    if (asyncValue is AsyncError) {
      final state = asyncValue.error;
      if (state is LoggedUserControllerStateNewUsernameIsAlreadyTaken) {
        setState(() {
          _isUsernameAlreadyTaken = true;
          _canValidateTextField = true;
        });
      } else if (state is LoggedUserControllerStateEmptyUsername) {
        setState(() {
          _isUsernameEmpty = true;
          _canValidateTextField = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(
      loggedUserControllerProvider,
      (_, next) => _onLoggedUserControllerStateChanged(next, context),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TitleLarge(context.str.username),
          const GapVertical16(),
          TextFormField(
            decoration: InputDecoration(hintText: context.str.usernameHintText),
            onChanged: (String value) {
              _onTextFieldChanged(value, ref);
            },
            validator: (_) => _validate(context),
            autovalidateMode: AutovalidateMode.always,
            onTapOutside: (_) {
              FocusScope.of(context).unfocus();
            },
          ),
        ],
      ),
    );
  }
}
