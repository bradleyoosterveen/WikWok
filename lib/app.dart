import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forui/forui.dart';
import 'package:wikwok/cubits/saved_articles_cubit.dart';
import 'package:wikwok/cubits/update_cubit.dart';
import 'package:wikwok/screens/articles_screen.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final theme = FThemes.zinc.dark;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => SavedArticlesCubit()),
        BlocProvider(
          lazy: false,
          create: (context) => UpdateCubit()..get(),
        ),
      ],
      child: AnnotatedRegion<SystemUiOverlayStyle>(
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
      ),
    );
  }
}
