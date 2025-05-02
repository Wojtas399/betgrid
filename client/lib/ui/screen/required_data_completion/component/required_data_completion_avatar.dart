import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../dependency_injection.dart';
import '../../../component/dialog/actions_dialog_component.dart';
import '../../../component/gap/gap_horizontal.dart';
import '../../../component/gap/gap_vertical.dart';
import '../../../extensions/build_context_extensions.dart';
import '../../../service/dialog_service.dart';
import '../../../service/image_service.dart';
import '../cubit/required_data_completion_cubit.dart';

class RequiredDataCompletionAvatar extends StatelessWidget {
  const RequiredDataCompletionAvatar({super.key});

  @override
  Widget build(BuildContext context) => const Column(
    children: [
      Padding(padding: EdgeInsets.fromLTRB(24, 24, 24, 0), child: _Avatar()),
      GapVertical16(),
      _AvatarButtons(),
    ],
  );
}

class _Avatar extends StatelessWidget {
  const _Avatar();

  @override
  Widget build(BuildContext context) {
    final String? avatarImgPath = context.select(
      (RequiredDataCompletionCubit cubit) => cubit.state.avatarImgPath,
    );

    return Center(
      child: SizedBox(
        width: 250,
        height: 250,
        child: CircleAvatar(
          backgroundImage:
              avatarImgPath != null ? FileImage(File(avatarImgPath)) : null,
          child:
              avatarImgPath == null
                  ? Icon(
                    Icons.person,
                    size: 128,
                    color: context.colorScheme.onSecondaryContainer,
                  )
                  : null,
        ),
      ),
    );
  }
}

class _AvatarButtons extends StatelessWidget {
  const _AvatarButtons();

  Future<void> _onChangeAvatar(BuildContext context) async {
    final _AvatarImageSource? source = await _askForAvatarImageSource(context);
    if (source == null) return;
    final String? avatarImgPath = await switch (source) {
      _AvatarImageSource.gallery => pickImage(),
      _AvatarImageSource.camera => capturePhoto(),
    };
    if (context.mounted) {
      context.read<RequiredDataCompletionCubit>().updateAvatar(avatarImgPath);
    }
  }

  void _onDeleteAvatar(BuildContext context) {
    context.read<RequiredDataCompletionCubit>().updateAvatar(null);
  }

  Future<_AvatarImageSource?> _askForAvatarImageSource(
    BuildContext context,
  ) async {
    return await getIt<DialogService>().askForAction<_AvatarImageSource>(
      title: context.str.requiredDataCompletionSelectAvatarSource,
      actions: [
        ActionsDialogItem(
          icon: const Icon(Icons.image),
          label: context.str.requiredDataCompletionAvatarSelectionGallery,
          value: _AvatarImageSource.gallery,
        ),
        ActionsDialogItem(
          icon: const Icon(Icons.camera_alt),
          label: context.str.requiredDataCompletionAvatarSelectionCamera,
          value: _AvatarImageSource.camera,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool doesAvatarExist = context.select(
      (RequiredDataCompletionCubit cubit) => cubit.state.doesAvatarExist,
    );

    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: doesAvatarExist ? 125 : 175,
            child: FilledButton(
              onPressed: () => _onChangeAvatar(context),
              child: Text(
                doesAvatarExist
                    ? context.str.requiredDataCompletionChangeAvatar
                    : context.str.requiredDataCompletionSelectAvatar,
              ),
            ),
          ),
          if (doesAvatarExist) ...[
            const GapHorizontal16(),
            SizedBox(
              width: 125,
              child: OutlinedButton(
                onPressed: () => _onDeleteAvatar(context),
                child: Text(context.str.delete),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

enum _AvatarImageSource { gallery, camera }
