import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'dependency_injection.dart';
import 'firebase_options.dart';
import 'model/user.dart';
import 'ui/config/router/app_router.dart';
import 'ui/config/theme/theme.dart';
import 'ui/controller/theme_mode_cubit.dart';
import 'ui/controller/theme_primary_color_controller.dart';
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
    ProviderScope(
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => getIt.get<ThemeModeCubit>(),
          ),
        ],
        child: const _MyApp(),
      ),
    ),
  );
}

class _MyApp extends ConsumerWidget {
  const _MyApp();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<ThemePrimaryColor> themePrimaryColor = ref.watch(
      themePrimaryColorControllerProvider,
    );
    final themeMode = context.watch<ThemeModeCubit>().state;

    return MaterialApp.router(
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
      themeMode: themeMode.toMaterialThemeMode,
      theme: AppTheme.lightTheme(themePrimaryColor.value?.toMaterialColor),
      darkTheme: AppTheme.darkTheme(themePrimaryColor.value?.toMaterialColor),
    );
  }
}
