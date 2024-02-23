import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../model/user.dart';
import '../../../component/gap/gap_vertical.dart';
import '../../../component/text/title.dart';
import '../../../extensions/build_context_extensions.dart';
import '../../../provider/logged_user_data_notifier_provider.dart';
import '../notifier/required_data_completion_notifier_provider.dart';

class RequiredDataCompletionUsername extends ConsumerStatefulWidget {
  const RequiredDataCompletionUsername({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _State();
}

class _State extends ConsumerState<RequiredDataCompletionUsername> {
  bool _isUsernameEmpty = false;
  bool _isUsernameAlreadyTaken = false;

  String? _validate(BuildContext context) {
    if (_isUsernameEmpty) return context.str.requiredField;
    if (_isUsernameAlreadyTaken) return context.str.usernameAlreadyTaken;
    return null;
  }

  void _onLoggedUserDataChanged(
    AsyncValue<User?> asyncValue,
    BuildContext context,
  ) {
    if (asyncValue is AsyncError &&
        asyncValue.error
            is LoggedUserDataNotifierExceptionNewUsernameIsAlreadyTaken) {
      setState(() {
        _isUsernameAlreadyTaken = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(
      loggedUserDataNotifierProvider,
      (previous, next) {
        _onLoggedUserDataChanged(next, context);
      },
    );
    ref.listen(
      requiredDataCompletionNotifierProvider,
      (previous, next) {
        setState(() {
          _isUsernameEmpty = next.username.isEmpty;
        });
      },
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
              ref
                  .read(requiredDataCompletionNotifierProvider.notifier)
                  .updateUsername(value);
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
