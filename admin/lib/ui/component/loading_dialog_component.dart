import 'package:flutter/material.dart';

import 'gap/gap_vertical.dart';

class LoadingDialog extends StatelessWidget {
  const LoadingDialog({super.key});

  @override
  Widget build(BuildContext context) => const AlertDialog(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(10.0)),
    ),
    contentPadding: EdgeInsets.all(24),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircularProgressIndicator(),
        GapVertical16(),
        Text('Ładowanie...'),
      ],
    ),
  );
}
