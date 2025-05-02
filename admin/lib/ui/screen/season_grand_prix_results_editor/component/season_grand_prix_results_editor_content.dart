import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../component/gap/gap_vertical.dart';
import '../../../component/padding_component.dart';
import '../../../component/text_component.dart';
import '../../../extensions/build_context_extensions.dart';
import '../cubit/season_grand_prix_results_editor_cubit.dart';
import '../cubit/season_grand_prix_results_editor_state.dart';
import 'season_grand_prix_results_editor_app_bar.dart';
import 'season_grand_prix_results_editor_quali.dart';
import 'season_grand_prix_results_editor_race.dart';

class SeasonGrandPrixResultsEditorContent extends StatelessWidget {
  const SeasonGrandPrixResultsEditorContent({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: SeasonGrandPrixResultsEditorAppBar(),
      body: SafeArea(child: _Body()),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body();

  @override
  Widget build(BuildContext context) {
    final SeasonGrandPrixResultsEditorState state =
        context.watch<SeasonGrandPrixResultsEditorCubit>().state;

    return switch (state) {
      SeasonGrandPrixResultsEditorStateInitial() => const Center(
        child: CircularProgressIndicator(),
      ),
      SeasonGrandPrixResultsEditorStateLoaded() => SingleChildScrollView(
        child: Padding8(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const GapVertical24(),
              _Section(
                title: context.str.seasonGrandPrixResultsEditorQualifications,
                body: const SeasonGrandPrixResultsEditorQuali(),
              ),
              const GapVertical24(),
              _Section(
                title: context.str.seasonGrandPrixResultsEditorRace,
                body: const SeasonGrandPrixResultsEditorRace(),
              ),
            ],
          ),
        ),
      ),
    };
  }
}

class _Section extends StatelessWidget {
  final String title;
  final Widget body;

  const _Section({required this.title, required this.body});

  @override
  Widget build(BuildContext context) => _CustomCard(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 16.0,
      children: [TitleLarge(title, fontWeight: FontWeight.bold), body],
    ),
  );
}

class _CustomCard extends StatelessWidget {
  final Widget child;

  const _CustomCard({required this.child});

  @override
  Widget build(BuildContext context) => SizedBox(
    width: double.infinity,
    child: Card(
      color: context.colorScheme.surfaceContainer,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: context.colorScheme.surfaceContainerHighest),
        borderRadius: BorderRadius.circular(10),
      ),
      clipBehavior: Clip.hardEdge,
      child: Padding16(child: child),
    ),
  );
}
