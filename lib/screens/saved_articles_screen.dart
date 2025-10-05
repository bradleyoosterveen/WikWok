import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forui/forui.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wikwok/cubits/saved_articles_cubit.dart';
import 'package:wikwok/models/article.dart';
import 'package:wikwok/widgets/banner.dart';
import 'package:wikwok/widgets/circular_progress.dart';

class SavedArticlesScreen extends StatefulWidget {
  const SavedArticlesScreen({super.key});

  static route() => MaterialPageRoute(
        builder: (context) => const SavedArticlesScreen(),
      );

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
    return FScaffold(
      header: FHeader.nested(
        prefixes: [
          FButton.icon(
            style: FButtonStyle.ghost(),
            child: const Icon(FIcons.arrowLeft),
            onPress: () => Navigator.pop(context),
          ),
        ],
        title: const Text('Saved articles'),
      ),
      child: SafeArea(
        top: false,
        child: Material(
          color: Colors.transparent,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: BlocBuilder<SavedArticlesCubit, List<Article>?>(
                  builder: (context, state) => switch (state) {
                    List<Article> articles => articles.isNotEmpty
                        ? ListView.builder(
                            padding: EdgeInsets.zero,
                            itemCount: articles.length,
                            itemBuilder: (context, index) => ListTile(
                              onTap: () =>
                                  launchUrl(Uri.parse(articles[index].url)),
                              leading: AspectRatio(
                                aspectRatio: 1,
                                child: WikWokBanner(
                                  src: articles[index].imageUrl,
                                  fill: true,
                                ),
                              ),
                              textColor: Colors.white,
                              title: Text(articles[index].title),
                              subtitle: Text(articles[index].subtitle),
                              trailing: FButton.icon(
                                style: FButtonStyle.ghost(),
                                onPress: () => context
                                    .read<SavedArticlesCubit>()
                                    .unsave(articles[index].title),
                                child: const Icon(FIcons.trash),
                              ),
                            ),
                          )
                        : Center(
                            child: Text(
                              'No saved articles',
                              style: context.theme.typography.xl,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                    _ => wCircularProgress,
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
