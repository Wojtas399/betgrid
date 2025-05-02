import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

import '../../dependency_injection.dart';
import '../component/confirmation_dialog_component.dart';
import '../component/loading_dialog_component.dart';
import '../config/router/app_router.dart';
import '../extensions/build_context_extensions.dart';

@singleton
class DialogService {
  bool _isLoadingDialogOpened = false;

  void showLoadingDialog() {
    final BuildContext? context =
        getIt<AppRouter>().navigatorKey.currentContext;
    if (!_isLoadingDialogOpened && context != null) {
      _isLoadingDialogOpened = true;
      showDialog(
        context: context,
        builder: (_) => const LoadingDialog(),
        barrierDismissible: false,
      );
    }
  }

  Future<bool?> askForConfirmation({
    required String title,
    required String message,
  }) async {
    final BuildContext? context =
        getIt<AppRouter>().navigatorKey.currentContext;
    return context != null
        ? await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => ConfirmationDialog(title: title, message: message),
        )
        : null;
  }

  void closeLoadingDialog() {
    final BuildContext? context =
        getIt<AppRouter>().navigatorKey.currentContext;
    if (_isLoadingDialogOpened && context != null) {
      Navigator.of(context, rootNavigator: true).pop();
      _isLoadingDialogOpened = false;
    }
  }

  Future<T?> showFullScreenDialog<T>(Widget dialog) async {
    final BuildContext? context =
        getIt<AppRouter>().navigatorKey.currentContext;
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
            CurvedAnimation(parent: anim1, curve: Curves.easeInOutQuart),
          ),
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 500),
    );
  }

  Future<void> showAlertDialog({
    required String title,
    required String message,
  }) async {
    final BuildContext? context =
        getIt<AppRouter>().navigatorKey.currentContext;
    if (context != null) {
      await showDialog(
        context: context,
        builder:
            (_) => AlertDialog(
              title: Text(title),
              content: Text(message),
              actions: [
                TextButton(
                  onPressed: context.maybePop,
                  child: Text(context.str.close),
                ),
              ],
            ),
      );
    }
  }

  void showSnackbarMessage(
    String message, {
    bool showCloseIcon = false,
    Duration duration = const Duration(seconds: 4),
  }) {
    final BuildContext? context =
        getIt<AppRouter>().navigatorKey.currentContext;
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
}
