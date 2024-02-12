import 'package:flutter/material.dart';

import 'text/headline.dart';

class GrandPrixNameComponent extends StatelessWidget {
  final String? name;

  const GrandPrixNameComponent({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          HeadlineMedium(
            name ?? '--',
            fontWeight: FontWeight.bold,
          ),
        ],
      ),
    );
  }
}
