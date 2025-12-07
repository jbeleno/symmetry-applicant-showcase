import 'dart:io';
import 'package:news_app_clean_architecture/core/usecase/usecase.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/entities/article.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/repository/article_repository.dart';

/// UseCase responsible for updating an existing article.
class UpdateArticleUseCase implements UseCase<void, UpdateArticleParams> {
  final ArticleRepository _articleRepository;

  UpdateArticleUseCase(this._articleRepository);

  @override
  Future<void> call({UpdateArticleParams? params}) {
    return _articleRepository.updateArticle(params!.article, params.image);
  }
}

/// Parameters required to update an article.
class UpdateArticleParams {
  final ArticleEntity article;
  final File? image;

  UpdateArticleParams({required this.article, this.image});
}
