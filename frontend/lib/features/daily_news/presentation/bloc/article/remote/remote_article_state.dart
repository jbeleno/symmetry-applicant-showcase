import 'package:equatable/equatable.dart';
import 'package:dio/dio.dart';
import '../../../../domain/entities/article.dart';

/// Base state for the remote articles feature.
abstract class RemoteArticlesState extends Equatable {
  final List<ArticleEntity>? articles;
  final DioException? error;

  const RemoteArticlesState({this.articles, this.error});

  @override
  List<Object?> get props => [articles, error];
}

/// State indicating that articles are currently being fetched.
class RemoteArticlesLoading extends RemoteArticlesState {
  const RemoteArticlesLoading();
}

/// State indicating that articles have been successfully loaded.
/// Maintains two lists:
/// - [articles]: The original list sorted by date (for search/chronological view).
/// - [feedArticles]: A shuffled version of the list for the discovery feed.
class RemoteArticlesDone extends RemoteArticlesState {
  final List<ArticleEntity> feedArticles;

  const RemoteArticlesDone(List<ArticleEntity> article,
      {List<ArticleEntity>? feedArticles})
      : feedArticles = feedArticles ?? article,
        super(articles: article);

  @override
  List<Object?> get props => [articles, feedArticles, error];
}

/// State indicating that an error occurred while fetching articles.
class RemoteArticlesError extends RemoteArticlesState {
  const RemoteArticlesError(DioException error) : super(error: error);
}
