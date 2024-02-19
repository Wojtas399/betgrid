import 'package:flutter/material.dart';

import '../../component/dialog/actions_dialog_component.dart';
import '../../component/gap/gap_vertical.dart';
import '../../extensions/build_context_extensions.dart';
import '../../service/dialog_service.dart';
import '../../service/image_service.dart';

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

  Future<void> _onPressed(BuildContext context) async {
    final _AvatarImageSource? source = await _askForAvatarImageSource(context);
    if (source == null) return;
    final String? avatarImgPath = await switch (source) {
      _AvatarImageSource.gallery => pickImage(),
      _AvatarImageSource.camera => capturePhoto(),
    };
    //TODO: Call method from notifier to change avatar image path
  }

  Future<_AvatarImageSource?> _askForAvatarImageSource(
    BuildContext context,
  ) async =>
      await askForAction<_AvatarImageSource>(
        title: context.str.requiredDataCompletionSelectAvatarSource,
        actions: [
          ActionsDialogItem(
            icon: const Icon(Icons.image),
            label: context.str.gallery,
            value: _AvatarImageSource.gallery,
          ),
          ActionsDialogItem(
            icon: const Icon(Icons.camera_alt),
            label: context.str.camera,
            value: _AvatarImageSource.camera,
          ),
        ],
      );

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FilledButton(
        onPressed: () => _onPressed(context),
        child: Text(context.str.requiredDataCompletionSelectAvatar),
      ),
    );
  }
}

enum _AvatarImageSource { gallery, camera }
