import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../model/user.dart';
import '../../../component/gap/gap_vertical.dart';
import '../../../component/text_component.dart';
import '../../../component/theme_primary_color_selection_component.dart';
import '../../../controller/theme_cubit.dart';
import '../../../extensions/build_context_extensions.dart';

class RequiredDataCompletionThemeColor extends StatelessWidget {
  const RequiredDataCompletionThemeColor({super.key});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TitleLarge(context.str.color),
            const GapVertical16(),
            const _Colors(),
          ],
        ),
      );
}

class _Colors extends StatelessWidget {
  const _Colors();

  void _onColorSelected(ThemePrimaryColor primaryColor, BuildContext context) {
    context.read<ThemeCubit>().changePrimaryColor(primaryColor);
  }

  @override
  Widget build(BuildContext context) {
    final ThemePrimaryColor? selectedThemePrimaryColor = context.select(
      (ThemeCubit cubit) => cubit.state?.primaryColor,
    );

    return ThemePrimaryColorSelection(
      selectedColor: selectedThemePrimaryColor,
      onColorSelected: (ThemePrimaryColor color) =>
          _onColorSelected(color, context),
    );
  }
}
