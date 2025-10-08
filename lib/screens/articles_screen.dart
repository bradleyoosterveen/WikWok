import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forui/forui.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wikwok/cubits/settings_cubit.dart';
import 'package:wikwok/cubits/update_cubit.dart';
import 'package:wikwok/pages/article_page.dart';
import 'package:wikwok/screens/saved_articles_screen.dart';
import 'package:wikwok/screens/settings_screen.dart';

class ArticlesScreen extends StatelessWidget {
  const ArticlesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final direction = context.select(
      (SettingsCubit cubit) => cubit.state.doomScrollDirection,
    );

    return FScaffold(
      childPad: false,
      child: Stack(
        children: [
          PageView.builder(
            scrollDirection: direction,
            itemBuilder: (context, index) => ArticlePage(index: index),
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
            onPress: () => SavedArticlesScreen.push(context),
            child: const Icon(FIcons.library),
          ),
          FButton.icon(
            style: FButtonStyle.ghost(),
            onPress: () => SettingsScreen.push(context),
            child: const Icon(FIcons.ellipsisVertical),
          ),
        ],
      ),
    );
  }
}
