import 'package:flutter/material.dart';

import 'text/title.dart';

class Avatar extends StatelessWidget {
  final String? avatarUrl;
  final String? username;

  const Avatar({super.key, this.avatarUrl, this.username});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundImage: avatarUrl != null ? NetworkImage(avatarUrl!) : null,
      child: username == null && avatarUrl == null
          ? const CircularProgressIndicator()
          : avatarUrl == null
              ? TitleLarge(
                  '${username?[0].toUpperCase()}',
                  fontWeight: FontWeight.bold,
                )
              : null,
    );
  }
}
