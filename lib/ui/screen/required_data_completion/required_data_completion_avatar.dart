import 'package:flutter/material.dart';

import '../../component/gap/gap_vertical.dart';
import '../../extensions/build_context_extensions.dart';

class RequiredDataCompletionAvatar extends StatelessWidget {
  const RequiredDataCompletionAvatar({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(24, 24, 24, 0),
          child: _Avatar(),
        ),
        GapVertical16(),
        _AvatarButton(),
      ],
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 250,
        height: 250,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondaryContainer,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Icon(
            Icons.person,
            size: 128,
            color: Theme.of(context).colorScheme.onSecondaryContainer,
          ),
        ),
      ),
    );
  }
}

class _AvatarButton extends StatelessWidget {
  const _AvatarButton();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FilledButton(
        onPressed: () {
          //TODO
        },
        child: Text(context.str.requiredDataCompletionSelectAvatar),
      ),
    );
  }
}
