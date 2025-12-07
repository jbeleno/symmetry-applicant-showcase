import 'dart:io';
import 'package:news_app_clean_architecture/core/usecase/usecase.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/entities/article.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/repository/article_repository.dart';

/// UseCase responsible for creating a new article.
class CreateArticleUseCase implements UseCase<void, CreateArticleParams> {
  final ArticleRepository _articleRepository;

  CreateArticleUseCase(this._articleRepository);

  @override
  Future<void> call({CreateArticleParams? params}) {
    return _articleRepository.publishArticle(params!.article, params.image);
  }
}

/// Parameters required to create an article.
class CreateArticleParams {
  final ArticleEntity article;
  final File? image;

  CreateArticleParams({required this.article, this.image});
}
