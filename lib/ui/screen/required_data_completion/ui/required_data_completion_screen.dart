import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../model/user.dart' as user;
import '../../../../model/user.dart';
import '../../../component/button/big_button.dart';
import '../../../component/gap/gap_vertical.dart';
import '../../../controller/logged_user/logged_user_controller.dart';
import '../../../controller/theme_mode_controller.dart';
import '../../../extensions/build_context_extensions.dart';
import '../../../provider/logged_user_provider.dart';
import '../../../provider/theme/theme_primary_color_notifier_provider.dart';
import '../../../service/dialog_service.dart';
import '../controller/required_data_completion_controller.dart';
import 'required_data_completion_avatar.dart';
import 'required_data_completion_theme_color.dart';
import 'required_data_completion_theme_mode.dart';
import 'required_data_completion_username.dart';

class RequiredDataCompletionScreen extends ConsumerWidget {
  const RequiredDataCompletionScreen({super.key});

  void _onLoggedUserChanged(BuildContext context, AsyncValue<User?> state) {
    state.when(
      data: (user.User? loggedUser) {
        closeLoadingDialog();
        if (loggedUser != null) context.popRoute();
      },
      error: (_, __) => closeLoadingDialog(),
      loading: () => showLoadingDialog(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(
      loggedUserProvider,
      (_, next) => _onLoggedUserChanged(context, next),
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
    final String username = ref.read(
      requiredDataCompletionControllerProvider.select(
        (notifierState) => notifierState.username,
      ),
    );
    final String? avatarImgPath = ref.read(
      requiredDataCompletionControllerProvider.select(
        (notifierState) => notifierState.avatarImgPath,
      ),
    );
    final AsyncValue<user.ThemeMode> themeMode = ref.read(
      themeModeControllerProvider,
    );
    final AsyncValue<user.ThemePrimaryColor> themePrimaryColor = ref.read(
      themePrimaryColorNotifierProvider,
    );
    if (themeMode.hasValue && themePrimaryColor.hasValue) {
      await ref.read(loggedUserControllerProvider.notifier).addData(
            username: username,
            avatarImgPath: avatarImgPath,
            themeMode: themeMode.value!,
            themePrimaryColor: themePrimaryColor.value!,
          );
    }
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
