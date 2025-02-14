import 'package:flutter/material.dart';

class Avatar extends StatelessWidget {
  final String? avatarUrl;
  final String? username;
  final double? usernameFontSize;

  const Avatar({
    super.key,
    this.avatarUrl,
    this.username,
    this.usernameFontSize = 22,
  });

  @override
  Widget build(BuildContext context) => CircleAvatar(
    backgroundImage: avatarUrl != null ? NetworkImage(avatarUrl!) : null,
    child:
        username == null && avatarUrl == null
            ? const CircularProgressIndicator()
            : avatarUrl == null
            ? Text(
              '${username?[0].toUpperCase()}',
              style: TextStyle(
                fontSize: usernameFontSize,
                fontWeight: FontWeight.bold,
              ),
            )
            : null,
  );
}
