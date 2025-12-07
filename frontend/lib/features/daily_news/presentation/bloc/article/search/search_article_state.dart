import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/entities/article.dart';

/// Base state for the article search feature.
abstract class SearchArticleState extends Equatable {
  final List<ArticleEntity>? articles;
  final DioException? error;

  const SearchArticleState({this.articles, this.error});

  @override
  List<Object?> get props => [articles, error];
}

/// Initial state before any search is performed.
class SearchArticleInitial extends SearchArticleState {
  const SearchArticleInitial();
}

/// State indicating that a search operation is in progress.
class SearchArticleLoading extends SearchArticleState {
  const SearchArticleLoading();
}

/// State indicating that search results have been successfully retrieved.
class SearchArticleDone extends SearchArticleState {
  const SearchArticleDone(List<ArticleEntity> articles)
      : super(articles: articles);
}

/// State indicating that an error occurred during the search.
class SearchArticleError extends SearchArticleState {
  const SearchArticleError(DioException error) : super(error: error);
}
