import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wikwok/cubits/article_cubit.dart';
import 'package:wikwok/cubits/saved_articles_cubit.dart';
import 'package:wikwok/models/article.dart';
import 'package:wikwok/widgets/button/icon_button.dart';

class SavedArticlesScreen extends StatefulWidget {
  const SavedArticlesScreen({super.key});

  @override
  State<SavedArticlesScreen> createState() => _SavedArticlesScreenState();
}

class _SavedArticlesScreenState extends State<SavedArticlesScreen> {
  @override
  void initState() {
    super.initState();

    context.read<SavedArticlesCubit>().get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: BlocBuilder<SavedArticlesCubit, List<Article>?>(
                builder: (context, state) => switch (state) {
                  List<Article> articles => articles.isNotEmpty
                      ? Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(24),
                              child: Row(
                                children: [
                                  Text(
                                    'Saved articles',
                                    style:
                                        Theme.of(context).textTheme.bodyLarge,
                                  ),
                                  const Spacer(),
                                  WikWokIconButton(
                                    icon: Icons.delete_sweep,
                                    label: 'Purge',
                                    onPressed: () => context
                                        .read<SavedArticlesCubit>()
                                        .unsaveAll(),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: ListView.builder(
                                itemCount: articles.length,
                                itemBuilder: (context, index) => ListTile(
                                  onTap: () => context
                                      .read<ArticleCubit>()
                                      .openUrl(context, articles[index].title),
                                  leading: AspectRatio(
                                    aspectRatio: 1,
                                    child: Image.network(
                                      articles[index].image,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  textColor: Colors.white,
                                  title: Text(articles[index].title),
                                  subtitle: Text(articles[index].subtitle),
                                  trailing: WikWokIconButton(
                                    icon: Icons.delete,
                                    label: 'Delete',
                                    onPressed: () => context
                                        .read<SavedArticlesCubit>()
                                        .unsave(articles[index].title),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      : Center(
                          child: Text(
                            'No saved articles',
                            style: Theme.of(context).textTheme.headlineLarge,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                  _ => const Center(child: CircularProgressIndicator()),
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
