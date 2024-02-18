import 'package:flutter/material.dart';

import '../../component/gap/gap_vertical.dart';
import '../../component/text/title.dart';
import 'required_data_completion_theme_mode_selection.dart';

class RequiredDataCompletionScreen extends StatelessWidget {
  const RequiredDataCompletionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wymagane dane'),
        automaticallyImplyLeading: false,
      ),
      body: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(24, 24, 24, 0),
            child: _Avatar(),
          ),
          GapVertical16(),
          _AvatarButton(),
          GapVertical32(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TitleLarge('Nazwa użytkownika'),
                GapVertical16(),
                _Nick(),
              ],
            ),
          ),
          GapVertical32(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: TitleLarge('Motyw'),
          ),
          GapVertical16(),
          RequiredDataCompletionThemeModeSelection(),
        ],
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 250,
        height: 250,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondaryContainer,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Icon(
            Icons.person,
            size: 128,
            color: Theme.of(context).colorScheme.onSecondaryContainer,
          ),
        ),
      ),
    );
  }
}

class _AvatarButton extends StatelessWidget {
  const _AvatarButton();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FilledButton(
        onPressed: () {
          //TODO
        },
        child: const Text('Wybierz avatar'),
      ),
    );
  }
}

class _Nick extends StatelessWidget {
  const _Nick();

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      cursorColor: Theme.of(context).colorScheme.onBackground,
      decoration: InputDecoration(
        hintText: 'np. Jan123',
        fillColor: Theme.of(context).colorScheme.secondaryContainer,
      ),
      onTapOutside: (_) {
        FocusScope.of(context).unfocus();
      },
    );
  }
}
