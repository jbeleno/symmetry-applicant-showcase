import 'dart:io';
import 'package:dio/dio.dart';
import 'package:news_app_clean_architecture/core/resources/data_state.dart';
import 'package:news_app_clean_architecture/features/daily_news/data/data_sources/local/app_database.dart';
import 'package:news_app_clean_architecture/features/daily_news/data/data_sources/remote/firebase_article_service.dart';
import 'package:news_app_clean_architecture/features/daily_news/data/data_sources/remote/news_remote_data_source.dart';
import 'package:news_app_clean_architecture/features/daily_news/data/models/article.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/entities/article.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/repository/article_repository.dart';

/// Implementation of [ArticleRepository].
/// Orchestrates data fetching from multiple sources:
/// - [NewsRemoteDataSource]: External News API.
/// - [FirebaseArticleService]: Firestore for user-generated content.
/// - [AppDatabase]: Local SQLite database for bookmarks.
class ArticleRepositoryImpl implements ArticleRepository {
  final NewsRemoteDataSource _newsRemoteDataSource;
  final FirebaseArticleService _firebaseArticleService;
  final AppDatabase _appDatabase;

  ArticleRepositoryImpl(
    this._newsRemoteDataSource,
    this._firebaseArticleService,
    this._appDatabase,
  );

  @override
  Future<DataState<List<ArticleEntity>>> getNewsArticles() async {
    return _getArticlesAndMerge(null);
  }

  @override
  Future<DataState<List<ArticleEntity>>> searchArticles(String query) async {
    return _getArticlesAndMerge(query);
  }

  /// Helper method to fetch and merge articles from both Firebase and NewsAPI.
  ///
  /// 1. Fetches articles from Firestore (User generated).
  /// 2. Fetches articles from NewsAPI (External).
  /// 3. Merges lists, removing duplicates based on title.
  /// 4. Sorts the final list by [publishedAt] descending.
  Future<DataState<List<ArticleEntity>>> _getArticlesAndMerge(
      String? query) async {
    List<ArticleModel> allArticles = [];
    DioException? apiError;

    try {
      final firestoreArticles = await _firebaseArticleService.getArticles();
      if (query != null && query.isNotEmpty) {
        final lowerQuery = query.toLowerCase();
        final filtered = firestoreArticles.where((article) {
          return article.title.toLowerCase().contains(lowerQuery) ||
              article.content.toLowerCase().contains(lowerQuery);
        }).toList();
        allArticles.addAll(filtered);
      } else {
        allArticles.addAll(firestoreArticles);
      }
    } catch (e) {
      // Log error
    }

    try {
      List<ArticleModel> apiArticles;
      if (query != null && query.isNotEmpty) {
        apiArticles = await _newsRemoteDataSource.searchNewsArticles(query);
      } else {
        apiArticles = await _newsRemoteDataSource.getNewsArticles();
      }

      for (var apiArticle in apiArticles) {
        bool exists = allArticles.any((local) =>
            local.title.toLowerCase() == apiArticle.title.toLowerCase());
        if (!exists) {
          allArticles.add(apiArticle);
        }
      }
    } on DioException catch (e) {
      apiError = e;
    }

    if (allArticles.isNotEmpty) {
      allArticles.sort((a, b) {
        return b.publishedAt.compareTo(a.publishedAt);
      });

      return DataSuccess(allArticles);
    } else {
      return DataFailed(apiError ??
          DioException(
            requestOptions: RequestOptions(path: 'mixed_source'),
            error: "No se pudieron cargar noticias de ninguna fuente",
            type: DioExceptionType.unknown,
          ));
    }
  }

  @override
  Future<void> toggleLike(ArticleEntity article, String userId) async {
    await _firebaseArticleService.toggleLike(article.id, userId,
        article: ArticleModel.fromEntity(article));
  }

  @override
  Future<void> publishArticle(ArticleEntity article, File? image) async {
    String? imageUrl;
    if (image != null) {
      imageUrl = await _firebaseArticleService.uploadImage(image);
    }

    final newArticle = ArticleModel(
      id: article.id,
      authorId: article.authorId,
      authorName: article.authorName,
      authorAvatar: article.authorAvatar,
      title: article.title,
      description: article.description,
      content: article.content,
      thumbnailUrl: imageUrl ?? article.thumbnailUrl,
      publishedAt: article.publishedAt,
      category: article.category,
      url: article.url,
      likes: 0,
    );

    await _firebaseArticleService.createArticle(newArticle);
  }

  @override
  Future<void> updateArticle(ArticleEntity article, File? image) async {
    String? imageUrl;
    if (image != null) {
      imageUrl = await _firebaseArticleService.uploadImage(image);
    }

    final updatedArticle = ArticleModel.fromEntity(article).copyWith(
      thumbnailUrl: imageUrl ?? article.thumbnailUrl,
    );

    await _firebaseArticleService.updateArticle(updatedArticle);
  }

  @override
  Future<void> deleteArticle(ArticleEntity article) async {
    await _firebaseArticleService.deleteArticle(article.id);
  }

  @override
  Future<List<ArticleEntity>> getSavedArticles() async {
    return _appDatabase.articleDAO.getArticles();
  }

  @override
  Future<void> removeArticle(ArticleEntity article) {
    return _appDatabase.articleDAO
        .deleteArticle(ArticleModel.fromEntity(article));
  }

  @override
  Future<void> saveArticle(ArticleEntity article) {
    return _appDatabase.articleDAO
        .insertArticle(ArticleModel.fromEntity(article));
  }
}
