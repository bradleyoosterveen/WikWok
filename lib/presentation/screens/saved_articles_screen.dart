import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forui/forui.dart';
import 'package:wikwok/domain/models/article.dart';
import 'package:wikwok/presentation/cubits/saved_articles_cubit.dart';
import 'package:wikwok/presentation/screens/article_screen.dart';
import 'package:wikwok/presentation/widgets/banner.dart';
import 'package:wikwok/presentation/widgets/border.dart';
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
              BlocBuilder<SavedArticlesCubit, SavedArticlesState>(
                builder: (context, state) => switch (state) {
                  SavedArticlesLoadedState state => Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        itemCount: state.articles.length,
                        itemBuilder: (context, index) => _ListItem(
                          article: state.articles[index],
                        ),
                      ),
                    ),
                  SavedArticlesEmptyState _ => FCard(
                      style: (style) => style.copyWith(
                        decoration: style.decoration.copyWith(
                          border: WBorder.zero,
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

class _ListItem extends StatelessWidget {
  const _ListItem({
    required this.article,
  });

  final Article article;

  @override
  Widget build(BuildContext context) {
    return FItem(
      prefix: SizedBox(
        width: 64,
        child: AspectRatio(
          aspectRatio: 1,
          child: WBanner(
            src: article.thumbnailUrl,
            fill: true,
            showGradient: false,
            showBackground: false,
            shouldWrapInSafeArea: false,
          ),
        ),
      ),
      title: Text(article.title),
      subtitle: Text(article.subtitle),
      onPress: () => ArticleScreen.push(context, article: article),
    );
  }
}
