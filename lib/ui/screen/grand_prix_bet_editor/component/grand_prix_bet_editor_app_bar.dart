import 'package:flutter/material.dart';

import '../../../component/gap/gap_horizontal.dart';
import '../../../extensions/build_context_extensions.dart';

class GrandPrixBetEditorAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const GrandPrixBetEditorAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  void _onSave(BuildContext context) {
    //TODO
  }

  @override
  Widget build(BuildContext context) => AppBar(
        centerTitle: false,
        title: Text(context.str.grandPrixBetEditorScreenTitle),
        actions: [
          FilledButton(
            onPressed: () => _onSave(context),
            child: Text(context.str.save),
          ),
          const GapHorizontal16(),
        ],
      );
}
