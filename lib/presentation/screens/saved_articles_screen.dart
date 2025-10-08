import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forui/forui.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wikwok/domain/models/article.dart';
import 'package:wikwok/presentation/cubits/saved_articles_cubit.dart';
import 'package:wikwok/presentation/widgets/banner.dart';
import 'package:wikwok/presentation/widgets/circular_progress.dart';

class SavedArticlesScreen extends StatefulWidget {
  const SavedArticlesScreen({super.key});

  static push(BuildContext context) =>
      Navigator.of(context).push(SavedArticlesScreen._route());

  static MaterialPageRoute _route() =>
      MaterialPageRoute(builder: (context) => const SavedArticlesScreen());

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
        title: const Text('Library'),
      ),
      child: SafeArea(
        top: false,
        child: Material(
          color: Colors.transparent,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              BlocBuilder<SavedArticlesCubit, List<Article>?>(
                builder: (context, state) => switch (state) {
                  List<Article> articles => articles.isNotEmpty
                      ? Expanded(
                          child: ListView.builder(
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            itemCount: articles.length,
                            itemBuilder: (context, index) => ListTile(
                              onTap: () =>
                                  launchUrl(Uri.parse(articles[index].url)),
                              leading: AspectRatio(
                                aspectRatio: 1,
                                child: Builder(
                                  builder: (context) => WBanner(
                                    src: articles[index].thumbnailUrl,
                                    fill: true,
                                  ),
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
                          ),
                        )
                      : FCard(
                          style: (style) => style.copyWith(
                            decoration: style.decoration.copyWith(
                              border: Border.all(width: 0),
                            ),
                          ),
                          title: const Text('Your library is empty'),
                          subtitle: const SizedBox.shrink(),
                          child: const Text(
                            'Add some articles to your library.',
                          ),
                        ),
                  _ => const WCircularProgress(),
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
