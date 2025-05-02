import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../component/gap/gap_horizontal.dart';
import '../../component/gap/gap_vertical.dart';
import '../../extensions/build_context_extensions.dart';
import 'cubit/sign_in_cubit.dart';

class SignInBody extends StatelessWidget {
  const SignInBody({super.key});

  @override
  Widget build(BuildContext context) => SafeArea(
    child: Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'BetGrid',
            style: Theme.of(context).textTheme.displayMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: context.colorScheme.primary,
            ),
          ),
          const GapVertical64(),
          const _SignInWithGoogleButton(),
          const GapVertical32(),
        ],
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
          const Text('Zaloguj'),
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
