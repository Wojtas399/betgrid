import 'package:auto_route/auto_route.dart';
import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../model/grand_prix.dart';
import '../../component/gap/gap_horizontal.dart';
import '../../component/text/body.dart';
import '../../component/text/title.dart';
import '../../config/router/app_router.dart';
import '../../provider/bet_mode_provider.dart';
import '../../provider/grand_prix_bet_status_provider.dart';
import '../../service/formatter_service.dart';

class HomeGrandPrixItem extends StatefulWidget {
  final int roundNumber;
  final GrandPrix grandPrix;

  const HomeGrandPrixItem({
    super.key,
    required this.roundNumber,
    required this.grandPrix,
  });

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<HomeGrandPrixItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late final Animation<double> scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    )..forward();
    scaleAnimation = Tween<double>(begin: 0.25, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOut,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onPressed(BuildContext context) {
    context.navigateTo(GrandPrixBetRoute(
      grandPrixId: widget.grandPrix.id,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      child: SizedBox(
        width: double.infinity,
        child: Card(
          color: Theme.of(context).colorScheme.primary,
          clipBehavior: Clip.hardEdge,
          child: InkWell(
            onTap: () => _onPressed(context),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  _CountryFlag(
                    countryAlpha2Code: widget.grandPrix.countryAlpha2Code,
                  ),
                  const GapHorizontal16(),
                  Expanded(
                    child: _GrandPrixDescription(
                      roundNumber: widget.roundNumber,
                      gpName: widget.grandPrix.name,
                      startDate: widget.grandPrix.startDate,
                      endDate: widget.grandPrix.endDate,
                    ),
                  ),
                  _BetStatus(grandPrixId: widget.grandPrix.id),
                ],
              ),
            ),
          ),
        ),
      ),
      builder: (context, child) {
        return Transform.scale(
          scale: scaleAnimation.value,
          child: child,
        );
      },
    );
  }
}

class _CountryFlag extends StatelessWidget {
  final String countryAlpha2Code;

  const _CountryFlag({required this.countryAlpha2Code});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(8),
      child: CountryFlag.fromCountryCode(
        countryAlpha2Code,
        height: 48,
        width: 62,
        borderRadius: 8,
      ),
    );
  }
}

class _GrandPrixDescription extends StatelessWidget {
  final int roundNumber;
  final String gpName;
  final DateTime startDate;
  final DateTime endDate;

  const _GrandPrixDescription({
    required this.roundNumber,
    required this.gpName,
    required this.startDate,
    required this.endDate,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BodyMedium(
          'Runda $roundNumber',
          color: Theme.of(context).colorScheme.outlineVariant,
          fontWeight: FontWeight.bold,
        ),
        TitleMedium(
          gpName,
          color: Theme.of(context).canvasColor,
          fontWeight: FontWeight.bold,
        ),
        BodyMedium(
          '${startDate.toDayAndMonthName()} - ${endDate.toDayAndMonthName()}',
          color: Theme.of(context).colorScheme.outlineVariant,
        ),
      ],
    );
  }
}

class _BetStatus extends ConsumerWidget {
  final String grandPrixId;

  const _BetStatus({required this.grandPrixId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final BetMode betMode = ref.watch(betModeProvider);
    final AsyncValue<GrandPrixBetStatus?> betStatus = ref.watch(
      grandPrixBetStatusProvider(grandPrixId),
    );

    return switch (betMode) {
      BetMode.preview => const SizedBox(),
      BetMode.edit => Icon(
          switch (betStatus.value) {
            GrandPrixBetStatus.pending => Icons.circle_outlined,
            GrandPrixBetStatus.inProgress => Icons.timelapse,
            GrandPrixBetStatus.completed => Icons.check_circle,
            _ => Icons.circle_outlined,
          },
          color: switch (betStatus.value) {
            GrandPrixBetStatus.pending =>
              Theme.of(context).colorScheme.outlineVariant,
            GrandPrixBetStatus.inProgress => Colors.amberAccent,
            GrandPrixBetStatus.completed => const Color(0xFF6BD65F),
            _ => Theme.of(context).colorScheme.outlineVariant,
          },
        ),
    };
  }
}
