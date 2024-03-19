import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../model/user.dart' as user;
import '../../component/avatar_component.dart';
import '../../component/dialog/actions_dialog_component.dart';
import '../../controller/logged_user/logged_user_controller.dart';
import '../../extensions/build_context_extensions.dart';
import '../../provider/logged_user_provider.dart';
import '../../service/dialog_service.dart';
import '../../service/image_service.dart';

enum _AvatarActions { selectFromGallery, capturePhoto, delete }

class ProfileAvatar extends ConsumerWidget {
  const ProfileAvatar({super.key});

  Future<void> _onPressed(BuildContext context, WidgetRef ref) async {
    final _AvatarActions? action = await _askForAvatarAction(context);
    switch (action) {
      case _AvatarActions.selectFromGallery:
        await _changeAvatar(ImageSource.gallery, ref);
      case _AvatarActions.capturePhoto:
        await _changeAvatar(ImageSource.camera, ref);
      case _AvatarActions.delete:
        await _deleteAvatar(ref);
      case null:
        break;
    }
  }

  Future<_AvatarActions?> _askForAvatarAction(BuildContext context) async =>
      await askForAction<_AvatarActions>(
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

  Future<void> _changeAvatar(ImageSource imageSource, WidgetRef ref) async {
    final String? newAvatarImgPath = await switch (imageSource) {
      ImageSource.camera => capturePhoto(),
      ImageSource.gallery => pickImage(),
    };
    if (newAvatarImgPath != null) {
      showLoadingDialog();
      await ref
          .read(loggedUserControllerProvider.notifier)
          .updateAvatar(newAvatarImgPath);
      closeLoadingDialog();
    }
  }

  Future<void> _deleteAvatar(WidgetRef ref) async {
    showLoadingDialog();
    await ref.read(loggedUserControllerProvider.notifier).updateAvatar(null);
    closeLoadingDialog();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String? username = ref.watch(
      loggedUserProvider.select(
        (AsyncValue<user.User?> loggedUserData) =>
            loggedUserData.value?.username,
      ),
    );
    final String? avatarUrl = ref.watch(
      loggedUserProvider.select(
        (AsyncValue<user.User?> loggedUser) => loggedUser.value?.avatarUrl,
      ),
    );

    return GestureDetector(
      onTap: () {
        _onPressed(context, ref);
      },
      child: Center(
        child: SizedBox(
          width: 250,
          height: 250,
          child: Avatar(
            avatarUrl: avatarUrl,
            username: username,
          ),
        ),
      ),
    );
  }
}
