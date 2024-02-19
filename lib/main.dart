import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'dependency_injection.dart';
import 'firebase_options.dart';
import 'ui/config/router/app_router.dart';
import 'ui/config/theme/theme.dart';
import 'ui/riverpod_provider/theme_color_notifier_provider.dart';
import 'ui/riverpod_provider/theme_notifier_provider.dart';

void main() async {
  configureDependencies();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Intl.defaultLocale = 'pl';
  runApp(
    const ProviderScope(
      child: _MyApp(),
    ),
  );
}

class _MyApp extends ConsumerWidget {
  const _MyApp();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeColor themeColor = ref.watch(themeColorNotifierProvider);

    return MaterialApp.router(
      title: 'BetGrid',
      routerConfig: getIt<AppRouter>().config(),
      localizationsDelegates: const [
        Str.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('pl')],
      themeMode: ref.watch(themeNotifierProvider),
      theme: themeColor == ThemeColor.defaultRed
          ? AppTheme.lightThemeDefault
          : AppTheme.lightTheme(themeColor.value),
      darkTheme: themeColor == ThemeColor.defaultRed
          ? AppTheme.darkThemeDefault
          : AppTheme.darkTheme(themeColor.value),
    );
  }
}
