import 'package:flutter/material.dart';

import '../../component/button/big_button.dart';
import '../../component/gap/gap_vertical.dart';
import '../../extensions/build_context_extensions.dart';
import 'required_data_completion_avatar.dart';
import 'required_data_completion_theme_color.dart';
import 'required_data_completion_theme_mode.dart';
import 'required_data_completion_username.dart';

class RequiredDataCompletionScreen extends StatelessWidget {
  const RequiredDataCompletionScreen({super.key});

  @override
  Widget build(BuildContext context) {
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

class _SubmitButton extends StatelessWidget {
  const _SubmitButton();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: BigButton(
        onPressed: () {
          //TODO: Call submit method from notifier
        },
        label: context.str.save,
      ),
    );
  }
}
