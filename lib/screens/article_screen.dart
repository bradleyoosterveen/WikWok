import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wikwok/cubits/article_cubit.dart';
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

    context.read<ArticleCubit>().prefetch(context, widget.index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _body(),
    );
  }

  Widget _body() {
    final article = context.watch<ArticleCubit>().getArticle(widget.index);

    return AnimatedSwitcher(
      duration: const Duration(
        milliseconds: 300,
      ),
      child: article == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : _content(article),
    );
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
        SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            article.subtitle,
                            style:
                                Theme.of(context).textTheme.labelMedium?.apply(
                                      color: Colors.white.withOpacity(0.76),
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
                  ),
                  Column(
                    children: [
                      const WikWokIconButton(
                        icon: Icons.more_vert,
                        label: 'More',
                      ),
                      const WikWokIconButton(
                        icon: Icons.bookmark_border,
                        label: 'Save',
                      ),
                      WikWokIconButton(
                        icon: Icons.share,
                        label: 'Share',
                        onPressed: () {
                          context.read<ArticleCubit>().copyToClipboard(context, widget.index);
                        },
                      ),
                      WikWokIconButton(
                        icon: Icons.open_in_new,
                        label: 'Open',
                        onPressed: () {
                          context.read<ArticleCubit>().openUrl(context, widget.index);
                        },
                      ),
                    ],
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 24,
                ),
                child: Icon(
                  Icons.swipe_up,
                  size: 24,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
