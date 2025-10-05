import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wikwok/cubits/saved_articles_cubit.dart';
import 'package:wikwok/cubits/update_cubit.dart';
import 'package:wikwok/screens/article_screen.dart';
import 'package:wikwok/screens/saved_articles_screen.dart';
import 'package:wikwok/widgets/button/icon_button.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
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
          theme: ThemeData(
            pageTransitionsTheme: PageTransitionsTheme(
              builders: {
                for (var type in TargetPlatform.values)
                  type: const CupertinoPageTransitionsBuilder(),
              },
            ),
            scaffoldBackgroundColor: const Color(0xFF101212),
            useMaterial3: true,
            textTheme: GoogleFonts.robotoSlabTextTheme().apply(
              bodyColor: Colors.white,
              displayColor: Colors.white,
            ),
            iconTheme: const IconThemeData(
              color: Colors.white,
              weight: 10,
            ),
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.transparent,
              elevation: 0,
              iconTheme: IconThemeData(
                color: Colors.white,
              ),
            ),
          ),
          home: Builder(
            builder: (context) => Scaffold(
              body: DefaultTabController(
                length: 2,
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
                        child: SizedBox(
                          height:
                              MediaQuery.of(context).viewPadding.bottom + 16,
                        ),
                      ),
                    ),
                    const SafeArea(
                      child: _Version(),
                    ),
                    const _Actions(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Version extends StatefulWidget {
  const _Version();

  @override
  State<_Version> createState() => _VersionState();
}

class _VersionState extends State<_Version> {
  PackageInfo? _packageInfo;
  bool _show = false;

  @override
  void initState() {
    super.initState();

    _loadPackageInfo();
  }

  Future<void> _loadPackageInfo() async {
    _packageInfo = await PackageInfo.fromPlatform();
    setState(() {});
  }

  String get _versionText {
    final info = _packageInfo;

    if (info == null) return '-';

    return '${info.version}+${info.buildNumber}';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onDoubleTap: () => setState(() => _show = !_show),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: _show ? Text(_versionText) : null,
      ),
    );
  }
}

class _Actions extends StatelessWidget {
  const _Actions();

  List<Widget> _actions(
    BuildContext context, {
    required UpdateState? updateState,
  }) =>
      [
        if (updateState is UpdateAvailableState) ...[
          WikWokIconButton(
              icon: Icons.file_download,
              label: updateState.version.toString(),
              onPressed: () => launchUrl(Uri.parse(updateState.url))),
        ],
        WikWokIconButton(
          icon: Icons.bookmarks_outlined,
          onPressed: () =>
              Navigator.of(context).push(SavedArticlesScreen.route()),
        ),
      ];

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 0,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: _actions(
              context,
              updateState: context.watch<UpdateCubit>().state,
            ),
          ),
        ),
      ),
    );
  }
}
