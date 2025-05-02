import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../model/user.dart' as user;
import '../../../common_cubit/theme/theme_cubit.dart';
import '../../../component/gap/gap_vertical.dart';
import '../../../component/text_component.dart';
import '../../../component/theme_primary_color_selection_component.dart';
import '../../../extensions/build_context_extensions.dart';

class ProfileThemePrimaryColor extends StatelessWidget {
  const ProfileThemePrimaryColor({super.key});

  void _onPrimaryColorChanged(
    user.ThemePrimaryColor primaryColor,
    BuildContext context,
  ) {
    context.read<ThemeCubit>().changePrimaryColor(primaryColor);
  }

  @override
  Widget build(BuildContext context) {
    final user.ThemePrimaryColor? themePrimaryColor = context.select(
      (ThemeCubit cubit) => cubit.state.primaryColor,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TitleLarge(context.str.color, color: context.colorScheme.outline),
          const GapVertical24(),
          ThemePrimaryColorSelection(
            selectedColor: themePrimaryColor,
            onColorSelected:
                (user.ThemePrimaryColor color) =>
                    _onPrimaryColorChanged(color, context),
          ),
        ],
      ),
    );
  }
}
