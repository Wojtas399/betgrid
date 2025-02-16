import 'dart:ui';

import 'package:betgrid_shared/firebase/firebase_betgrid.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:intl/intl.dart';

import 'dependency_injection.dart';
import 'firebase_options.dart';
import 'l10n/app_localizations.dart';
import 'ui/common_cubit/theme/theme_cubit.dart';
import 'ui/common_cubit/theme/theme_state.dart';
import 'ui/config/router/app_router.dart';
import 'ui/config/theme/theme.dart';
import 'ui/extensions/theme_mode_extensions.dart';
import 'ui/extensions/theme_primary_color_extensions.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  configureDependencies();

  await FirebaseBetgrid.initialize(
    name: 'betgrid',
    options: DefaultFirebaseOptions.currentPlatform,
  );
  if (const bool.fromEnvironment('emulated', defaultValue: false)) {
    FirebaseBetgrid.useEmulators();
  } else {
    FlutterError.onError = (errorDetails) {
      FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
    };
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };
  }

  Intl.defaultLocale = 'pl';
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then(
    (_) => runApp(
      BlocProvider(
        create: (_) => getIt.get<ThemeCubit>()..initialize(),
        child: const _MyApp(),
      ),
    ),
  );
}

class _MyApp extends StatelessWidget {
  const _MyApp();

  @override
  Widget build(BuildContext context) {
    final ThemeState themeState = context.watch<ThemeCubit>().state;

    return MaterialApp.router(
      title: 'BetGrid',
      routerConfig: getIt<AppRouter>().config(
        navigatorObservers: () => [HeroController()],
      ),
      localizationsDelegates: const [
        Str.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('pl')],
      themeMode: themeState.themeMode.toMaterialThemeMode,
      theme: AppTheme.lightTheme(themeState.primaryColor.toMaterialColor),
      darkTheme: AppTheme.darkTheme(themeState.primaryColor.toMaterialColor),
    );
  }
}
