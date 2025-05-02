import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../extensions/datetime_extensions.dart';
import '../cubit/new_season_grand_prix_dialog_cubit.dart';

class NewSeasonGrandPrixDialogStartDate extends StatefulWidget {
  const NewSeasonGrandPrixDialogStartDate({super.key});

  @override
  State<NewSeasonGrandPrixDialogStartDate> createState() => _State();
}

class _State extends State<NewSeasonGrandPrixDialogStartDate> {
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
        .map((state) => state.startDate)
        .listen((DateTime? startDate) {
          _controller.text = startDate?.toFullDate() ?? '';
        });
  }

  Future<void> _onTap(BuildContext context) async {
    final cubit = context.read<NewSeasonGrandPrixDialogCubit>();
    final DateTime? startDate = await showDatePicker(
      context: context,
      initialDate: cubit.state.startDate,
      firstDate: DateTime(cubit.season),
      lastDate: cubit.state.endDate ?? DateTime(cubit.season, 12, 31),
    );
    if (startDate != null) {
      cubit.onStartDateChanged(startDate);
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
