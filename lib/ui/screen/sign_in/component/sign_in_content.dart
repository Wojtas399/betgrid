import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../component/gap/gap_horizontal.dart';
import '../../../component/gap/gap_vertical.dart';
import '../../../component/text_component.dart';
import '../../../extensions/build_context_extensions.dart';
import '../cubit/sign_in_cubit.dart';
import 'sign_in_app_bar.dart';

class SignInContent extends StatelessWidget {
  const SignInContent({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: const SignInAppBar(),
    body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DisplayMedium(
              'BetGrid',
              fontWeight: FontWeight.bold,
              color: context.colorScheme.primary,
            ),
            const GapVertical64(),
            TitleLarge(
              context.str.signInScreenInfo,
              textAlign: TextAlign.center,
            ),
            const GapVertical32(),
            const _SignInWithGoogleButton(),
            const GapVertical32(),
          ],
        ),
      ),
    ),
  );
}

class _SignInWithGoogleButton extends StatelessWidget {
  const _SignInWithGoogleButton();

  @override
  Widget build(BuildContext context) => FilledButton(
    onPressed: context.read<SignInCubit>().signInWithGoogle,
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(context.str.signInScreenSignInButtonLabel),
          const GapHorizontal16(),
          SizedBox(
            height: 24,
            width: 24,
            child: SvgPicture.asset('assets/google_logo.svg'),
          ),
        ],
      ),
    ),
  );
}
