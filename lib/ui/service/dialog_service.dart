import 'package:flutter/material.dart';

import '../../dependency_injection.dart';
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
