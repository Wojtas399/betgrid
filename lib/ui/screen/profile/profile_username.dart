import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../model/user.dart' as user;
import '../../component/gap/gap_vertical.dart';
import '../../component/text/body.dart';
import '../../component/text/title.dart';
import '../../extensions/build_context_extensions.dart';
import '../../provider/logged_user_data_provider.dart';

class ProfileUsername extends ConsumerWidget {
  const ProfileUsername({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String? username = ref.watch(
      loggedUserDataProvider.select(
        (AsyncValue<user.User?> loggedUserData) =>
            loggedUserData.value?.username,
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: TitleLarge(
            context.str.username,
            color: Theme.of(context).colorScheme.outline,
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
                onPressed: () {},
                icon: const Icon(Icons.edit),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
