import 'dart:io';
import 'package:news_app_clean_architecture/core/resources/data_state.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/entities/article.dart';

/// Repository interface for managing articles.
/// Handles data operations from both Remote API and Local Database.
abstract class ArticleRepository {
  // API methods

  /// Fetches the latest news articles from the remote API.
  Future<DataState<List<ArticleEntity>>> getNewsArticles();

  /// Searches for articles matching the [query] string.
  Future<DataState<List<ArticleEntity>>> searchArticles(String query);

  /// Toggles the like status of an [article] for a specific [userId].
  Future<void> toggleLike(ArticleEntity article, String userId);

  /// Publishes a new [article] with an optional [image].
  Future<void> publishArticle(ArticleEntity article, File? image);

  /// Updates an existing [article] and optionally updates its [image].
  Future<void> updateArticle(ArticleEntity article, File? image);

  /// Permanently deletes an [article].
  Future<void> deleteArticle(ArticleEntity article);

  // Database methods

  /// Retrieves the list of bookmarked articles from the local database.
  Future<List<ArticleEntity>> getSavedArticles();

  /// Saves an [article] to the local database (bookmarks).
  Future<void> saveArticle(ArticleEntity article);

  /// Removes an [article] from the local database (bookmarks).
  Future<void> removeArticle(ArticleEntity article);
}
