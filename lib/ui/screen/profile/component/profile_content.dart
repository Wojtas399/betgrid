import 'package:flutter/material.dart';

import '../../../component/gap/gap_vertical.dart';
import '../../../extensions/build_context_extensions.dart';
import 'profile_avatar.dart';
import 'profile_theme_mode.dart';
import 'profile_theme_primary_color.dart';
import 'profile_username.dart';

class ProfileContent extends StatelessWidget {
  const ProfileContent({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(context.str.profileScreenTitle),
        ),
        body: const SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GapVertical24(),
                ProfileAvatar(),
                GapVertical40(),
                ProfileUsername(),
                GapVertical24(),
                ProfileThemeMode(),
                GapVertical24(),
                ProfileThemePrimaryColor(),
                GapVertical64(),
              ],
            ),
          ),
        ),
      );
}
