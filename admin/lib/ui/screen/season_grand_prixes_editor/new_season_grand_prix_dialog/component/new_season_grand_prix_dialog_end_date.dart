import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../extensions/datetime_extensions.dart';
import '../cubit/new_season_grand_prix_dialog_cubit.dart';

class NewSeasonGrandPrixDialogEndDate extends StatefulWidget {
  const NewSeasonGrandPrixDialogEndDate({super.key});

  @override
  State<NewSeasonGrandPrixDialogEndDate> createState() => _State();
}

class _State extends State<NewSeasonGrandPrixDialogEndDate> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  StreamSubscription<DateTime?>? _subscription;

  @override
  void dispose() {
    _controller.dispose();
    _subscription?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _subscription = context
        .read<NewSeasonGrandPrixDialogCubit>()
        .stream
        .map((state) => state.endDate)
        .listen((DateTime? endDate) {
          _controller.text = endDate?.toFullDate() ?? '';
        });
  }

  Future<void> _onTap(BuildContext context) async {
    final cubit = context.read<NewSeasonGrandPrixDialogCubit>();
    final DateTime? endDate = await showDatePicker(
      context: context,
      initialDate: cubit.state.endDate,
      firstDate: cubit.state.startDate ?? DateTime(cubit.season),
      lastDate: DateTime(cubit.season, 12, 31),
    );
    if (endDate != null) {
      cubit.onEndDateChanged(endDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _controller,
      focusNode: _focusNode,
      onTap: () => _onTap(context),
      onTapOutside: (_) {
        _focusNode.unfocus();
      },
    );
  }
}
