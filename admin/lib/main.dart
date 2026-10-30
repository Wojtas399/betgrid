import 'package:betgrid_shared/firebase/firebase_betgrid.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import 'dependency_injection.dart';
import 'firebase_options_dev.dart' as dev;
import 'firebase_options_prod.dart' as prod;
import 'l10n/app_localizations.dart';
import 'ui/config/router/app_router.dart';
import 'ui/config/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  configureDependencies();

  await FirebaseBetgrid.initialize(
    options: switch (appFlavor) {
      'dev' => dev.DefaultFirebaseOptions.currentPlatform,
      'prod' => prod.DefaultFirebaseOptions.currentPlatform,
      _ => throw UnsupportedError('Unknown flavor: $appFlavor'),
    },
  );
  if (const bool.fromEnvironment('emulated', defaultValue: false)) {
    FirebaseBetgrid.useEmulators();
  }

  Intl.defaultLocale = 'pl';
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]).then((_) => runApp(const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp.router(
    title: 'BetGrid Admin',
    localizationsDelegates: Str.localizationsDelegates,
    supportedLocales: Str.supportedLocales,
    theme: AppTheme.lightTheme(),
    routerConfig: getIt<AppRouter>().config(),
  );
}
