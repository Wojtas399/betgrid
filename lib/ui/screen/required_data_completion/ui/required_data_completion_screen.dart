import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../model/user.dart' as user;
import '../../../../model/user.dart';
import '../../../component/button/big_button.dart';
import '../../../component/gap/gap_vertical.dart';
import '../../../extensions/build_context_extensions.dart';
import '../../../provider/logged_user_data_notifier_provider.dart';
import '../../../provider/notifier/required_data_completion/required_data_completion_notifier_provider.dart';
import '../../../provider/theme/theme_mode_notifier_provider.dart';
import '../../../provider/theme/theme_primary_color_notifier_provider.dart';
import '../../../service/dialog_service.dart';
import 'required_data_completion_avatar.dart';
import 'required_data_completion_theme_color.dart';
import 'required_data_completion_theme_mode.dart';
import 'required_data_completion_username.dart';

class RequiredDataCompletionScreen extends ConsumerWidget {
  const RequiredDataCompletionScreen({super.key});

  void _onLoggedUserDataNotifierStateChanged(
    BuildContext context,
    AsyncValue<User?> state,
  ) {
    if (state is AsyncLoading) {
      showLoadingDialog();
    } else if (state is AsyncData) {
      closeLoadingDialog();
      if (state.value != null) context.popRoute();
    } else if (state is AsyncError) {
      closeLoadingDialog();
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(
      loggedUserDataNotifierProvider,
      (previous, next) {
        _onLoggedUserDataNotifierStateChanged(context, next);
      },
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
      requiredDataCompletionNotifierProvider.select(
        (notifierState) => notifierState.username,
      ),
    );
    final String? avatarImgPath = ref.read(
      requiredDataCompletionNotifierProvider.select(
        (notifierState) => notifierState.avatarImgPath,
      ),
    );
    final AsyncValue<user.ThemeMode> themeMode = ref.read(
      themeModeNotifierProvider,
    );
    final AsyncValue<user.ThemePrimaryColor> themePrimaryColor = ref.read(
      themePrimaryColorNotifierProvider,
    );
    if (themeMode.hasValue && themePrimaryColor.hasValue) {
      await ref.read(loggedUserDataNotifierProvider.notifier).addLoggedUserData(
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
