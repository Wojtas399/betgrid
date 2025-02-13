import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common_cubit/theme/theme_cubit.dart';
import '../../../common_cubit/theme/theme_state.dart';
import '../../../component/button/big_button.dart';
import '../../../component/gap/gap_vertical.dart';
import '../../../extensions/build_context_extensions.dart';
import '../cubit/required_data_completion_cubit.dart';
import 'required_data_completion_avatar.dart';
import 'required_data_completion_theme_color.dart';
import 'required_data_completion_theme_mode.dart';
import 'required_data_completion_username.dart';

class RequiredDataCompletionContent extends StatelessWidget {
  const RequiredDataCompletionContent({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
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

class _SubmitButton extends StatelessWidget {
  const _SubmitButton();

  Future<void> _onPressed(BuildContext context) async {
    final ThemeState themeState = context.read<ThemeCubit>().state;
    await context.read<RequiredDataCompletionCubit>().submit(
          themeMode: themeState.themeMode,
          themePrimaryColor: themeState.primaryColor,
        );
  }

  @override
  Widget build(BuildContext context) => Center(
        child: BigButton(
          onPressed: () => _onPressed(context),
          label: context.str.save,
        ),
      );
}
