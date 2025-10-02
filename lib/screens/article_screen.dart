import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wikwok/cubits/article_cubit.dart';
import 'package:wikwok/cubits/save_article_cubit.dart';
import 'package:wikwok/models/article.dart';
import 'package:wikwok/widgets/banner.dart';
import 'package:wikwok/widgets/button/icon_button.dart';

class ArticleScreen extends StatefulWidget {
  const ArticleScreen({
    required this.index,
    super.key,
  });

  final int index;

  @override
  State<ArticleScreen> createState() => _ArticleScreenState();
}

class _ArticleScreenState extends State<ArticleScreen> {
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
        body: _View(index: widget.index),
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
  @override
  void initState() {
    super.initState();

    context.read<ArticleCubit>().fetch(context, widget.index);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ArticleCubit, Article?>(
        builder: (context, state) => AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: switch (state) {
                Article article => _content(article),
                _ => const Center(child: CircularProgressIndicator()),
              },
            ));
  }

  Widget _content(
    Article article,
  ) {
    return Column(
      children: [
        Expanded(
          child: WikWokBanner(
            src: article.image,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(24),
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            article.subtitle,
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium
                                ?.apply(
                                  color: Colors.white.withValues(alpha: 0.76),
                                ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            article.title,
                            style: Theme.of(context).textTheme.headlineLarge,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            article.content,
                            style: Theme.of(context).textTheme.bodyMedium,
                            maxLines: 6,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      children: [
                        BlocBuilder<SaveArticleCubit, bool?>(
                          builder: (context, state) => switch (state) {
                            true => WikWokIconButton(
                                icon: Icons.bookmark,
                                label: 'Saved',
                                onPressed: () => context
                                    .read<SaveArticleCubit>()
                                    .unsave(article.title),
                              ),
                            false => WikWokIconButton(
                                icon: Icons.bookmark_outline,
                                label: 'Save',
                                onPressed: () => context
                                    .read<SaveArticleCubit>()
                                    .save(article.title),
                              ),
                            _ => const SizedBox.shrink(),
                          },
                        ),
                        WikWokIconButton(
                          icon: Icons.share,
                          label: 'Share',
                          onPressed: () {
                            context
                                .read<ArticleCubit>()
                                .copyToClipboard(context, article.title);
                          },
                        ),
                        WikWokIconButton(
                          icon: Icons.open_in_new,
                          label: 'Open',
                          onPressed: () {
                            context
                                .read<ArticleCubit>()
                                .openUrl(context, article.title);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
