import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forui/forui.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wikwok/cubits/article_cubit.dart';
import 'package:wikwok/cubits/save_article_cubit.dart';
import 'package:wikwok/cubits/settings_cubit.dart';
import 'package:wikwok/models/article.dart';
import 'package:wikwok/models/settings.dart';
import 'package:wikwok/widgets/banner.dart';
import 'package:wikwok/widgets/circular_progress.dart';

class ArticlePage extends StatefulWidget {
  const ArticlePage({
    required this.index,
    super.key,
  });

  final int index;

  @override
  State<ArticlePage> createState() => _ArticlePageState();
}

class _ArticlePageState extends State<ArticlePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ArticleCubit()),
        BlocProvider(create: (context) => SaveArticleCubit()),
      ],
      child: Scaffold(
        body: MultiBlocListener(
          listeners: [
            BlocListener<ArticleCubit, Article?>(
              listener: (context, state) => switch (state) {
                Article article =>
                  context.read<SaveArticleCubit>().get(article.title),
                _ => {},
              },
            ),
          ],
          child: _View(index: widget.index),
        ),
      ),
    );
  }
}

class _View extends StatefulWidget {
  const _View({
    required this.index,
  });

  final int index;

  @override
  State<_View> createState() => _ViewState();
}

class _ViewState extends State<_View> {
  List<ConnectivityResult> _connectionStatus = [ConnectivityResult.none];

  final Connectivity _connectivity = Connectivity();

  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  @override
  void initState() {
    super.initState();

    context.read<ArticleCubit>().fetch(widget.index);

    initConnectivity();

    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  Future<void> initConnectivity() async {
    late List<ConnectivityResult> result;
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (_) {
      return;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  void _updateConnectionStatus(List<ConnectivityResult> result) => setState(() {
        _connectionStatus = result;
      });

  bool get _hasWifi => _connectionStatus.contains(ConnectivityResult.wifi);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ArticleCubit, Article?>(
      builder: (context, state) => AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: switch (state) {
          Article article => _content(article),
          _ => const WCircularProgress(),
        },
      ),
    );
  }

  Widget _content(Article article) => Column(
        children: [
          Expanded(
            child: Builder(builder: (context) {
              final shouldDownloadFullSizeImages = context.select(
                (SettingsCubit settings) =>
                    settings.state.shouldDownloadFullSizeImages,
              );

              final urlWifiOnly =
                  _hasWifi ? article.originalImageUrl : article.thumbnailUrl;

              return WBanner(
                src: switch (shouldDownloadFullSizeImages) {
                  ShouldDownloadFullSizeImages.yes => article.originalImageUrl,
                  ShouldDownloadFullSizeImages.no => article.thumbnailUrl,
                  _ => urlWifiOnly,
                },
              );
            }),
          ),
          Padding(
            padding: const EdgeInsets.all(24).subtract(
              const EdgeInsets.only(top: 24),
            ),
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      BlocBuilder<SaveArticleCubit, bool?>(
                        builder: (context, state) => switch (state) {
                          true => FButton.icon(
                              style: FButtonStyle.ghost(),
                              onPress: () => context
                                  .read<SaveArticleCubit>()
                                  .unsave(article.title),
                              child: const Icon(FIcons.bookMarked),
                            ),
                          false => FButton.icon(
                              style: FButtonStyle.ghost(),
                              onPress: () => context
                                  .read<SaveArticleCubit>()
                                  .save(article.title),
                              child: const Icon(FIcons.book),
                            ),
                          _ => const SizedBox.shrink(),
                        },
                      ),
                      const SizedBox(width: 8),
                      FButton.icon(
                        style: FButtonStyle.ghost(),
                        onPress: () => context
                            .read<ArticleCubit>()
                            .copyToClipboard(article.title),
                        child: const Icon(FIcons.share2),
                      ),
                      const SizedBox(width: 8),
                      FButton.icon(
                        style: FButtonStyle.ghost(),
                        onPress: () => launchUrl(Uri.parse(article.url)),
                        child: const Icon(FIcons.externalLink),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  FCard(
                    subtitle: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Text(
                        article.subtitle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    title: Text(article.title),
                    child: Text(
                      article.content,
                      maxLines: 6,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      );
}
