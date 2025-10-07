import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forui/forui.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wikwok/cubits/saved_articles_cubit.dart';
import 'package:wikwok/cubits/update_cubit.dart';
import 'package:wikwok/screens/article_screen.dart';
import 'package:wikwok/screens/saved_articles_screen.dart';

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
          builder: (_, child) => FAnimatedTheme(data: theme, child: child!),
          home: Builder(
            builder: (context) => FScaffold(
              childPad: false,
              child: Stack(
                children: [
                  PageView.builder(
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, index) =>
                        ArticleScreen(index: index),
                  ),
                  Positioned(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        color: Colors.transparent,
                        height: MediaQuery.of(context).viewPadding.bottom + 16,
                      ),
                    ),
                  ),
                  const _Header(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    final updateState = context.watch<UpdateCubit>().state;

    return Align(
      alignment: Alignment.topCenter,
      child: FHeader.nested(
        suffixes: [
          if (updateState is UpdateAvailableState) ...[
            FButton.icon(
              style: FButtonStyle.ghost(),
              onPress: () => launchUrl(Uri.parse(updateState.url)),
              child: const Icon(FIcons.sparkles),
            ),
          ],
          FButton.icon(
            style: FButtonStyle.ghost(),
            onPress: () =>
                Navigator.of(context).push(SavedArticlesScreen.route()),
            child: const Icon(FIcons.library),
          ),
        ],
      ),
    );
  }
}
