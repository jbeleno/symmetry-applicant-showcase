import 'dart:io';
import 'package:dio/dio.dart';
import 'package:news_app_clean_architecture/core/constants/constants.dart';
import 'package:news_app_clean_architecture/features/daily_news/data/models/article.dart';

/// Remote Data Source for fetching news from the external NewsAPI.
/// Uses [Dio] for HTTP requests.
class NewsRemoteDataSource {
  final Dio _dio;

  NewsRemoteDataSource(this._dio);

  /// Fetches top headlines based on default country and category.
  Future<List<ArticleModel>> getNewsArticles() async {
    return _fetchArticles({
      'apiKey': newsAPIKey,
      'country': countryQuery,
      'category': categoryQuery,
    });
  }

  /// Searches for news articles matching the [query].
  Future<List<ArticleModel>> searchNewsArticles(String query) async {
    return _fetchArticles({
      'apiKey': newsAPIKey,
      'q': query,
      'sortBy': 'publishedAt',
    });
  }

  /// Helper method to execute the API request and parse the response.
  Future<List<ArticleModel>> _fetchArticles(
      Map<String, dynamic> queryParams) async {
    final response = await _dio.get(
      '$newsAPIBaseURL/top-headlines',
      queryParameters: queryParams,
    );

    if (response.statusCode == HttpStatus.ok) {
      final data = response.data;
      if (data is Map<String, dynamic> && data['articles'] is List) {
        final List<dynamic> articlesJson = data['articles'];
        return articlesJson
            .map((json) => ArticleModel.fromJson(json as Map<String, dynamic>))
            .toList();
      }
    }
    throw DioException(
      error: response.statusMessage,
      response: response,
      type: DioExceptionType.badResponse,
      requestOptions: response.requestOptions,
    );
  }
}
