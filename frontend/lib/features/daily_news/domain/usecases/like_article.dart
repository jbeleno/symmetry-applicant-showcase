import 'package:news_app_clean_architecture/core/usecase/usecase.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/entities/article.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/repository/article_repository.dart';

/// Parameters for toggling the like status of an article.
class ToggleLikeParams {
  final ArticleEntity article;
  final String userId;
  ToggleLikeParams(this.article, this.userId);
}

/// UseCase responsible for toggling the like status of an article.
class LikeArticleUseCase implements UseCase<void, ToggleLikeParams> {
  final ArticleRepository _articleRepository;

  LikeArticleUseCase(this._articleRepository);

  @override
  Future<void> call({ToggleLikeParams? params}) {
    return _articleRepository.toggleLike(params!.article, params.userId);
  }
}
