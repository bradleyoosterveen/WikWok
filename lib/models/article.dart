class Article {
  final int id;
  final String subtitle;
  final String title;
  final String content;
  final String imageUrl;
  final String url;

  Article({
    required this.id,
    required this.subtitle,
    required this.title,
    required this.content,
    required this.imageUrl,
    required this.url,
  });

  factory Article.fromJson(Map<String, dynamic> json) => Article(
        id: json['pageid'] as int,
        subtitle: json['description'] as String,
        title: json['titles']['normalized'] as String,
        content: json['extract'] as String,
        imageUrl: json['thumbnail']['source'] as String,
        url: json['content_urls']['mobile']['page'] as String,
      );
}
