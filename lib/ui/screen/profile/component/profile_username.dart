import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../component/gap/gap_vertical.dart';
import '../../../component/text_component.dart';
import '../../../extensions/build_context_extensions.dart';
import '../../../service/dialog_service.dart';
import '../cubit/profile_cubit.dart';
import 'profile_username_dialog.dart';

class ProfileUsername extends StatelessWidget {
  const ProfileUsername({super.key});

  Future<void> _onEdit(BuildContext context) async {
    await showFullScreenDialog(
      BlocProvider.value(
        value: context.read<ProfileCubit>(),
        child: const ProfileUsernameDialog(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String? username = context.select(
      (ProfileCubit cubit) => cubit.state.username,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: TitleLarge(
            context.str.username,
            color: context.colorScheme.outline,
          ),
        ),
        const GapVertical8(),
        Padding(
          padding: const EdgeInsets.only(left: 24, right: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              BodyLarge('$username'),
              IconButton(
                onPressed: () => _onEdit(context),
                icon: const Icon(Icons.edit),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
