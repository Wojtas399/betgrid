import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import 'sign_in_app_bar.dart';
import 'sign_in_content.dart';

@RoutePage()
class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: SignInAppBar(),
      body: SignInContent(),
    );
  }
}
