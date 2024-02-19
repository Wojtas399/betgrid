import 'package:flutter/material.dart';

import '../../component/gap/gap_vertical.dart';
import '../../component/text/title.dart';
import '../../extensions/build_context_extensions.dart';

class RequiredDataCompletionUsername extends StatelessWidget {
  const RequiredDataCompletionUsername({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TitleLarge(context.str.username),
          const GapVertical16(),
          TextFormField(
            decoration: const InputDecoration(hintText: 'np. Jan123'),
            onTapOutside: (_) {
              FocusScope.of(context).unfocus();
            },
          ),
        ],
      ),
    );
  }
}
