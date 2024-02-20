import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../component/button/big_button.dart';
import '../../../component/gap/gap_vertical.dart';
import '../../../extensions/build_context_extensions.dart';
import '../../../provider/theme_mode_notifier_provider.dart';
import '../../../provider/theme_primary_color_notifier_provider.dart';
import '../../../service/dialog_service.dart';
import '../notifier/required_data_completion_notifier.dart';
import '../notifier/required_data_completion_notifier_state.dart';
import 'required_data_completion_avatar.dart';
import 'required_data_completion_theme_color.dart';
import 'required_data_completion_theme_mode.dart';
import 'required_data_completion_username.dart';

class RequiredDataCompletionScreen extends ConsumerWidget {
  const RequiredDataCompletionScreen({super.key});

  void _onNotifierStatusChanged(
    RequiredDataCompletionNotifierStatus? status,
    BuildContext context,
  ) {
    if (status is RequiredDataCompletionNotifierStatusSavingData) {
      showLoadingDialog();
    } else if (status is RequiredDataCompletionNotifierStatusDataSaved) {
      closeLoadingDialog();
      context.popRoute();
    } else {
      closeLoadingDialog();
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(
      requiredDataCompletionNotifierProvider.select(
        (state) => state.value?.status,
      ),
      (previous, next) => _onNotifierStatusChanged(next, context),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(context.str.requiredDataCompletionScreenTitle),
        automaticallyImplyLeading: false,
      ),
      body: const SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              RequiredDataCompletionAvatar(),
              GapVertical32(),
              RequiredDataCompletionUsername(),
              GapVertical32(),
              RequiredDataCompletionThemeMode(),
              GapVertical32(),
              RequiredDataCompletionThemeColor(),
              GapVertical32(),
              _SubmitButton(),
              GapVertical64(),
            ],
          ),
        ),
      ),
    );
  }
}

class _SubmitButton extends ConsumerWidget {
  const _SubmitButton();

  Future<void> _onPressed(BuildContext context, WidgetRef ref) async {
    await ref.read(requiredDataCompletionNotifierProvider.notifier).submit(
          themeMode: ref.read(themeModeNotifierProvider),
          themePrimaryColor: ref.read(themePrimaryColorNotifierProvider),
        );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: BigButton(
        onPressed: () => _onPressed(context, ref),
        label: context.str.save,
      ),
    );
  }
}
