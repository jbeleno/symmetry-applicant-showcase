import 'package:equatable/equatable.dart';

/// Entity representing a news article.
class ArticleEntity extends Equatable {
  final String id;
  final String title;
  final String description;
  final String content;
  final String category;
  final String thumbnailUrl;
  final DateTime publishedAt;
  final String? authorId;
  final String authorName;
  final String authorAvatar;
  final String? url;
  final int likes;
  final List<String> likedIds;

  const ArticleEntity({
    required this.id,
    required this.title,
    this.description = '',
    required this.content,
    required this.category,
    required this.thumbnailUrl,
    required this.publishedAt,
    this.authorId,
    required this.authorName,
    required this.authorAvatar,
    this.url,
    required this.likes,
    this.likedIds = const [],
  });

  /// Creates a copy of this article with the given fields replaced with the new values.
  ArticleEntity copyWith({
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
    return ArticleEntity(
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

  /// Toggles the like status for a given [userId].
  /// Returns a new [ArticleEntity] with updated like count and list of likers.
  ArticleEntity toggleLike(String userId) {
    final isLiked = likedIds.contains(userId);
    List<String> newLikedIds = List.from(likedIds);
    int newLikesCount = likes;

    if (isLiked) {
      newLikedIds.remove(userId);
      newLikesCount = (newLikesCount - 1).clamp(0, 999999);
    } else {
      newLikedIds.add(userId);
      newLikesCount++;
    }

    return copyWith(
      likes: newLikesCount,
      likedIds: newLikedIds,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        content,
        category,
        thumbnailUrl,
        publishedAt,
        authorId,
        authorName,
        authorAvatar,
        likes,
        likedIds,
      ];
}
