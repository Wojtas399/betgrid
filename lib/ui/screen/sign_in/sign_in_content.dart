import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

import '../../component/gap/gap_horizontal.dart';
import '../../component/gap/gap_vertical.dart';
import '../../extensions/build_context_extensions.dart';
import '../../provider/auth/auth_provider.dart';

class SignInContent extends StatelessWidget {
  const SignInContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'BetGrid',
              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
            const GapVertical64(),
            Text(
              Str.of(context).signInScreenInfo,
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const GapVertical32(),
            const _SignInWithGoogleButton(),
            const GapVertical32(),
          ],
        ),
      ),
    );
  }
}

class _SignInWithGoogleButton extends ConsumerWidget {
  const _SignInWithGoogleButton();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FilledButton(
      onPressed: ref.read(authProvider.notifier).signInWithGoogle,
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
}
