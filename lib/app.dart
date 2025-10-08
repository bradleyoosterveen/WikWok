import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forui/forui.dart';
import 'package:wikwok/cubits/connectivity_cubit.dart';
import 'package:wikwok/cubits/current_version_cubit.dart';
import 'package:wikwok/cubits/saved_articles_cubit.dart';
import 'package:wikwok/cubits/settings_cubit.dart';
import 'package:wikwok/cubits/update_cubit.dart';
import 'package:wikwok/screens/articles_screen.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late final _platformBrightness = MediaQuery.of(context).platformBrightness;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => SavedArticlesCubit()),
        BlocProvider(
          lazy: false,
          create: (context) => UpdateCubit()..get(),
        ),
        BlocProvider(
          lazy: false,
          create: (context) => CurrentVersionCubit()..get(),
        ),
        BlocProvider(
          lazy: false,
          create: (context) => SettingsCubit()..get(),
        ),
        BlocProvider(
          lazy: false,
          create: (context) => ConnectivityCubit()..initialize(),
        ),
      ],
      child: Builder(builder: (context) {
        final themeMode = context.select(
          (SettingsCubit cubit) => cubit.state.themeMode,
        );

        final theme = switch (themeMode) {
          ThemeMode.light => FThemes.zinc.light,
          ThemeMode.dark => FThemes.zinc.dark,
          ThemeMode.system => _platformBrightness == Brightness.dark
              ? FThemes.zinc.dark
              : FThemes.zinc.light,
        };

        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.light,
          child: MaterialApp(
            title: 'WikWok',
            theme: theme.toApproximateMaterialTheme().copyWith(
                  pageTransitionsTheme: PageTransitionsTheme(
                    builders: {
                      for (var platform in TargetPlatform.values)
                        platform: const CupertinoPageTransitionsBuilder(),
                    },
                  ),
                ),
            builder: (_, child) => FAnimatedTheme(
              data: theme,
              child: child ?? const SizedBox.shrink(),
            ),
            home: const ArticlesScreen(),
          ),
        );
      }),
    );
  }
}
