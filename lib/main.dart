import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    name: 'betgrid-dev',
    options: DefaultFirebaseOptions.currentPlatform,
  );

  if (const bool.fromEnvironment('emulated', defaultValue: false)) {
    FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
    FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);
    FirebaseFunctions.instance.useFunctionsEmulator('localhost', 5001);
    FirebaseStorage.instance.useStorageEmulator('localhost', 9199);
  }

  Intl.defaultLocale = 'pl';
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]).then(
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
      darkTheme: AppTheme.darkTheme(themeState.primaryColor.toMaterialColor),
    );
  }
}
