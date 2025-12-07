import 'package:floor/floor.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/entities/article.dart';

/// Data model for Article, compatible with Floor database and API JSON.
@Entity(tableName: 'article', primaryKeys: ['id'])
class ArticleModel extends ArticleEntity {
  const ArticleModel({
    required String id,
    required String title,
    String description = '',
    required String content,
    required String category,
    required String thumbnailUrl,
    required DateTime publishedAt,
    String? authorId,
    required String authorName,
    required String authorAvatar,
    String? url,
    required int likes,
    List<String> likedIds = const [],
  }) : super(
          id: id,
          title: title,
          description: description,
          content: content,
          category: category,
          thumbnailUrl: thumbnailUrl,
          publishedAt: publishedAt,
          authorId: authorId,
          authorName: authorName,
          authorAvatar: authorAvatar,
          url: url,
          likes: likes,
          likedIds: likedIds,
        );

  /// Creates an [ArticleModel] from a JSON map (API or Firestore).
  factory ArticleModel.fromJson(Map<String, dynamic> map) {
    return ArticleModel(
      id: map['id']?.toString() ??
          DateTime.now().millisecondsSinceEpoch.toString(),
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      content: map['content'] ?? '',
      category: map['category'] ?? 'General',
      thumbnailUrl: map['urlToImage'] ?? '',
      publishedAt:
          DateTime.tryParse(map['publishedAt'] ?? '') ?? DateTime.now(),
      authorId: map['author'] is Map ? map['author']['id'] : null,
      authorName: map['author'] is Map
          ? (map['author']['name'] ?? 'Unknown Author')
          : (map['author'] ?? 'Unknown Author'),
      authorAvatar: map['author'] is Map
          ? (map['author']['avatar'] ??
              'https://i.pravatar.cc/150?u=${map['author']['name'] ?? 'unknown'}')
          : 'https://i.pravatar.cc/150?u=${map['author'] ?? 'unknown'}',
      url: map['url'],
      likes: map['likes'] ?? 0,
      likedIds: List<String>.from(map['liked_by'] ?? []),
    );
  }

  /// Creates an [ArticleModel] from a domain [ArticleEntity].
  factory ArticleModel.fromEntity(ArticleEntity entity) {
    return ArticleModel(
      id: entity.id,
      title: entity.title,
      description: entity.description,
      content: entity.content,
      category: entity.category,
      thumbnailUrl: entity.thumbnailUrl,
      publishedAt: entity.publishedAt,
      authorId: entity.authorId,
      authorName: entity.authorName,
      authorAvatar: entity.authorAvatar,
      url: entity.url,
      likes: entity.likes,
      likedIds: entity.likedIds,
    );
  }

  @override
  ArticleModel copyWith({
    String? id,
    String? title,
    String? description,
    String? content,
    String? category,
    String? thumbnailUrl,
    DateTime? publishedAt,
    String? authorId,
    String? authorName,
    String? authorAvatar,
    String? url,
    int? likes,
    List<String>? likedIds,
  }) {
    return ArticleModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      content: content ?? this.content,
      category: category ?? this.category,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      publishedAt: publishedAt ?? this.publishedAt,
      authorId: authorId ?? this.authorId,
      authorName: authorName ?? this.authorName,
      authorAvatar: authorAvatar ?? this.authorAvatar,
      url: url ?? this.url,
      likes: likes ?? this.likes,
      likedIds: likedIds ?? this.likedIds,
    );
  }
}
