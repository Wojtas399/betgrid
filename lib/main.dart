import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';

import 'dependency_injection.dart';
import 'firebase_options.dart';
import 'ui/common_cubit/theme_cubit.dart';
import 'ui/common_cubit/theme_state.dart';
import 'ui/config/router/app_router.dart';
import 'ui/config/theme/theme.dart';
import 'ui/extensions/theme_mode_extensions.dart';
import 'ui/extensions/theme_primary_color_extensions.dart';

void main() async {
  configureDependencies();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Intl.defaultLocale = 'pl';
  runApp(
    BlocProvider(
      create: (_) => getIt.get<ThemeCubit>()..initialize(),
      child: const _MyApp(),
    ),
  );
}

class _MyApp extends StatelessWidget {
  const _MyApp();

  @override
  Widget build(BuildContext context) {
    final ThemeState? themeState = context.watch<ThemeCubit>().state;

    return themeState != null
        ? MaterialApp.router(
            title: 'BetGrid',
            routerConfig: getIt<AppRouter>().config(
              navigatorObservers: () => [
                HeroController(),
              ],
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
            darkTheme:
                AppTheme.darkTheme(themeState.primaryColor.toMaterialColor),
          )
        : const _SplashScreen();
  }
}

class _SplashScreen extends StatelessWidget {
  const _SplashScreen();

  @override
  Widget build(BuildContext context) {
    return const CircularProgressIndicator();
  }
}
