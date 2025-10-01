import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:wikwok/cubits/article_cubit.dart';
import 'package:wikwok/cubits/saved_articles_cubit.dart';
import 'package:wikwok/screens/article_screen.dart';
import 'package:wikwok/screens/saved_articles_screen.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: MaterialApp(
        title: 'WikWok',
        theme: ThemeData(
          scaffoldBackgroundColor: const Color(0xFF101212),
          useMaterial3: true,
          textTheme: GoogleFonts.spectralTextTheme().apply(
            bodyColor: Colors.white,
            displayColor: Colors.white,
          ),
          iconTheme: const IconThemeData(
            color: Colors.white,
            weight: 10,
          ),
        ),
        home: MultiBlocProvider(
          providers: [
            BlocProvider(create: (context) => ArticleCubit()),
            BlocProvider(create: (context) => SavedArticlesCubit()),
          ],
          child: Scaffold(
            body: DefaultTabController(
              length: 2,
              child: Column(
                children: [
                  Expanded(
                    child: TabBarView(
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        Stack(
                          children: [
                            PageView.builder(
                              scrollDirection: Axis.vertical,
                              itemBuilder: (context, index) =>
                                  ArticleScreen(index: index),
                            ),
                            const SafeArea(
                              child: _Version(),
                            ),
                          ],
                        ),
                        const SavedArticlesScreen(),
                      ],
                    ),
                  ),
                  const Material(
                    color: Color(0xFF101212),
                    child: SafeArea(
                      top: false,
                      child: TabBar(
                        dividerHeight: 0,
                        indicatorColor: Colors.transparent,
                        tabs: <Widget>[
                          Tab(icon: Icon(Icons.swipe_up)),
                          Tab(icon: Icon(Icons.bookmarks_outlined)),
                        ],
                      ),
                    ),
                  ),
                ],
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
