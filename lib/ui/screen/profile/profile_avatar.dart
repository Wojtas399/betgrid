import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../model/user.dart' as user;
import '../../provider/logged_user_data_provider.dart';

class ProfileAvatar extends ConsumerWidget {
  const ProfileAvatar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String? username = ref.watch(
      loggedUserDataProvider.select(
        (AsyncValue<user.User?> loggedUserData) =>
            loggedUserData.value?.username,
      ),
    );
    final String? avatarUrl = ref.watch(
      loggedUserDataProvider.select(
        (AsyncValue<user.User?> loggedUser) => loggedUser.value?.avatarUrl,
      ),
    );

    return GestureDetector(
      onTap: () {
        //TODO
      },
      child: Center(
        child: SizedBox(
          width: 250,
          height: 250,
          child: CircleAvatar(
            backgroundImage: avatarUrl != null ? NetworkImage(avatarUrl) : null,
            child: username == null && avatarUrl == null
                ? const CircularProgressIndicator()
                : avatarUrl == null
                    ? Text('${username?[0].toUpperCase()}')
                    : null,
          ),
        ),
      ),
    );
  }
}
