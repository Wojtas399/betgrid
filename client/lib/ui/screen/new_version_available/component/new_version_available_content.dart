import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../../component/button/big_button.dart';
import '../../../component/padding/padding_components.dart';
import '../../../component/text_component.dart';
import '../../../extensions/build_context_extensions.dart';

class NewVersionAvailableContent extends StatelessWidget {
  const NewVersionAvailableContent({super.key});

  @override
  Widget build(BuildContext context) {
    return const Material(
      child: Padding24(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 40,
          children: [_Logo(), _Description(), _Actions()],
        ),
      ),
    );
  }
}

class _Logo extends StatelessWidget {
  const _Logo();

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        DisplayLarge('Bet', fontWeight: FontWeight.bold),
        DisplayLarge('Grid', color: Colors.red, fontWeight: FontWeight.bold),
      ],
    );
  }
}

class _Description extends StatelessWidget {
  const _Description();

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 8,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleLarge(
          context.str.newVersionAvailableScreenTitle,
          fontWeight: FontWeight.bold,
        ),
        BodyMedium(context.str.newVersionAvailableDescription),
      ],
    );
  }
}

class _Actions extends StatelessWidget {
  const _Actions();

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 16,
      children: [
        BigButton.outlined(
          label: context.str.close,
          onPressed: context.maybePop,
        ),
      ],
    );
  }
}
