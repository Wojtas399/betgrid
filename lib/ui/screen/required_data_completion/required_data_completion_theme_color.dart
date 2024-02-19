import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../model/user.dart';
import '../../component/gap/gap_vertical.dart';
import '../../component/text/title.dart';
import '../../extensions/build_context_extensions.dart';
import '../../extensions/theme_primary_color_extensions.dart';
import '../../provider/theme_primary_color_notifier_provider.dart';

class RequiredDataCompletionThemeColor extends StatelessWidget {
  const RequiredDataCompletionThemeColor({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TitleLarge(context.str.color),
          const GapVertical16(),
          const _ColorTypes(),
        ],
      ),
    );
  }
}

class _ColorTypes extends ConsumerWidget {
  const _ColorTypes();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemePrimaryColor selectedThemePrimaryColor = ref.watch(
      themePrimaryColorNotifierProvider,
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: ThemePrimaryColor.values
          .map(
            (ThemePrimaryColor color) => _ColorItem(
              isSelected: selectedThemePrimaryColor == color,
              color: color.toMaterialColor,
              onPressed: () {
                ref
                    .read(themePrimaryColorNotifierProvider.notifier)
                    .changeThemePrimaryColor(color);
              },
            ),
          )
          .toList(),
    );
  }
}

class _ColorItem extends StatelessWidget {
  final Color color;
  final bool isSelected;
  final VoidCallback onPressed;

  const _ColorItem({
    required this.color,
    required this.isSelected,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: isSelected ? 1.25 : 1.0,
      child: Container(
        width: 32,
        height: 32,
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: isSelected
              ? Border.all(
                  color: Theme.of(context).colorScheme.onBackground,
                  width: 2.0,
                )
              : null,
        ),
        child: FilledButton(
          onPressed: onPressed,
          style: FilledButton.styleFrom(
            backgroundColor: color,
          ),
          child: const SizedBox(),
        ),
      ),
    );
  }
}
