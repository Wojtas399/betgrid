import 'package:flutter/material.dart';

import '../../dependency_injection.dart';
import '../component/dialog/actions_dialog_component.dart';
import '../component/dialog/loading_dialog.dart';
import '../config/router/app_router.dart';

bool _isLoadingDialogOpened = false;

void showLoadingDialog() {
  final BuildContext? context = getIt<AppRouter>().navigatorKey.currentContext;
  if (!_isLoadingDialogOpened && context != null) {
    _isLoadingDialogOpened = true;
    showDialog(
      context: context,
      builder: (_) => const LoadingDialog(),
      barrierDismissible: false,
    );
  }
}

void closeLoadingDialog() {
  final BuildContext? context = getIt<AppRouter>().navigatorKey.currentContext;
  if (_isLoadingDialogOpened && context != null) {
    Navigator.of(context, rootNavigator: true).pop();
    _isLoadingDialogOpened = false;
  }
}

Future<T?> askForAction<T>({
  required List<ActionsDialogItem> actions,
  String? title,
}) async {
  final BuildContext? context = getIt<AppRouter>().navigatorKey.currentContext;
  if (context == null) return null;
  return await showModalBottomSheet<T?>(
    context: context,
    builder: (BuildContext context) => ActionsDialog(
      actions: actions,
      title: title,
    ),
  );
}

void showSnackbarMessage(
  String message, {
  bool showCloseIcon = false,
  Duration duration = const Duration(seconds: 4),
}) {
  final BuildContext? context = getIt<AppRouter>().navigatorKey.currentContext;
  if (context != null) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        showCloseIcon: showCloseIcon,
        duration: duration,
        content: Text(message),
      ),
    );
  }
}

Future<T?> showFullScreenDialog<T>(Widget dialog) async {
  final BuildContext? context = getIt<AppRouter>().navigatorKey.currentContext;
  if (context == null) return null;
  return await showGeneralDialog<T?>(
    context: context,
    barrierColor: Colors.transparent,
    pageBuilder: (_, a1, a2) => Dialog.fullscreen(child: dialog),
    transitionBuilder: (BuildContext context, anim1, anim2, child) {
      return SlideTransition(
        position: Tween(
          begin: const Offset(0.0, 1.0),
          end: Offset.zero,
        ).animate(
          CurvedAnimation(
            parent: anim1,
            curve: Curves.easeInOutQuart,
          ),
        ),
        child: child,
      );
    },
    transitionDuration: const Duration(milliseconds: 500),
  );
}
