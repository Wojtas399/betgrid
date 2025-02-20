import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../dependency_injection.dart';
import '../../../component/avatar_component.dart';
import '../../../component/dialog/actions_dialog_component.dart';
import '../../../extensions/build_context_extensions.dart';
import '../../../service/dialog_service.dart';
import '../../../service/image_service.dart';
import '../cubit/profile_cubit.dart';

enum _AvatarActions { selectFromGallery, capturePhoto, delete }

class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({super.key});

  Future<void> _onPressed(BuildContext context) async {
    final _AvatarActions? action = await _askForAvatarAction(context);
    if (context.mounted) {
      switch (action) {
        case _AvatarActions.selectFromGallery:
          await _changeAvatar(ImageSource.gallery, context);
        case _AvatarActions.capturePhoto:
          await _changeAvatar(ImageSource.camera, context);
        case _AvatarActions.delete:
          await _deleteAvatar(context);
        case null:
          break;
      }
    }
  }

  Future<_AvatarActions?> _askForAvatarAction(BuildContext context) async =>
      await getIt<DialogService>().askForAction<_AvatarActions>(
        title: context.str.profileAvatarActionsTitle,
        actions: [
          ActionsDialogItem(
            icon: const Icon(Icons.image),
            label: context.str.profileAvatarActionsSelectFromGallery,
            value: _AvatarActions.selectFromGallery,
          ),
          ActionsDialogItem(
            icon: const Icon(Icons.camera_alt),
            label: context.str.profileAvatarActionsCapturePhoto,
            value: _AvatarActions.capturePhoto,
          ),
          ActionsDialogItem(
            icon: const Icon(Icons.delete),
            label: context.str.profileAvatarActionsDeleteImage,
            value: _AvatarActions.delete,
          ),
        ],
      );

  Future<void> _changeAvatar(
    ImageSource imageSource,
    BuildContext context,
  ) async {
    final String? newAvatarImgPath = await switch (imageSource) {
      ImageSource.camera => capturePhoto(),
      ImageSource.gallery => pickImage(),
    };
    final dialogService = getIt<DialogService>();
    if (newAvatarImgPath != null && context.mounted) {
      dialogService.showLoadingDialog();
      await context.read<ProfileCubit>().updateAvatar(newAvatarImgPath);
      dialogService.closeLoadingDialog();
    }
  }

  Future<void> _deleteAvatar(BuildContext context) async {
    final dialogService = getIt<DialogService>();
    dialogService.showLoadingDialog();
    await context.read<ProfileCubit>().updateAvatar(null);
    dialogService.closeLoadingDialog();
  }

  @override
  Widget build(BuildContext context) {
    final String? username = context.select(
      (ProfileCubit cubit) => cubit.state.username,
    );
    final String? avatarUrl = context.select(
      (ProfileCubit cubit) => cubit.state.avatarUrl,
    );

    return GestureDetector(
      onTap: () => _onPressed(context),
      child: Center(
        child: SizedBox(
          width: 250,
          height: 250,
          child: Avatar(avatarUrl: avatarUrl, username: username),
        ),
      ),
    );
  }
}
