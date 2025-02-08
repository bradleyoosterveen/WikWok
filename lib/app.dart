import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wikwok/cubits/article_cubit.dart';
import 'package:wikwok/screens/article_screen.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
          BlocProvider(
            create: (context) => ArticleCubit(),
          ),
        ],
        child: PageView.builder(
          scrollDirection: Axis.vertical,
          itemBuilder: (context, index) {
            return ArticleScreen(index: index);
          },
        ),
      ),
    );
  }
}
