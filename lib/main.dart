import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'dependency_injection.dart';
import 'firebase_options.dart';
import 'ui/config/router/app_router.dart';
import 'ui/config/theme/theme.dart';
import 'ui/config/theme/theme_notifier.dart';

void main() async {
  configureDependencies();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    ProviderScope(
      child: _MyApp(),
    ),
  );
}

class _MyApp extends ConsumerWidget {
  final _appRouter = AppRouter();

  _MyApp();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      routerConfig: _appRouter.config(),
      title: 'BetGrid',
      themeMode: ref.watch(themeNotifierProvider),
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
    );
  }
}
