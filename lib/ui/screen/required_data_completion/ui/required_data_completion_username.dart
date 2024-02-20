import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../component/gap/gap_vertical.dart';
import '../../../component/text/title.dart';
import '../../../extensions/build_context_extensions.dart';
import '../notifier/required_data_completion_notifier.dart';
import '../notifier/required_data_completion_notifier_state.dart';

class RequiredDataCompletionUsername extends ConsumerWidget {
  const RequiredDataCompletionUsername({super.key});

  String? _validate(
    RequiredDataCompletionNotifierStatus? notifierStatus,
    BuildContext context,
  ) {
    if (notifierStatus is RequiredDataCompletionNotifierStatusEmptyUsername) {
      return context.str.requiredField;
    } else if (notifierStatus
        is RequiredDataCompletionNotifierStatusUsernameAlreadyTaken) {
      return context.str.usernameAlreadyTaken;
    }
    return null;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifierStatus = ref.watch(
      requiredDataCompletionNotifierProvider.select(
        (state) => state.value?.status,
      ),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TitleLarge(context.str.username),
          const GapVertical16(),
          TextFormField(
            decoration: const InputDecoration(hintText: 'np. Jan123'),
            onChanged: (String value) {
              ref
                  .read(requiredDataCompletionNotifierProvider.notifier)
                  .updateUsername(value);
            },
            validator: (_) => _validate(notifierStatus, context),
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
