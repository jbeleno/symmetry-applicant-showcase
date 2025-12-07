import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app_clean_architecture/core/constants/constants.dart';
import 'package:news_app_clean_architecture/core/resources/data_state.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/entities/article.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/usecases/get_articles.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/usecases/like_article.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/remote/remote_article_state.dart';

/// Manages the state of the remote articles feed.
/// Handles fetching, shuffling for the feed, and optimistic UI updates for likes.
class RemoteArticlesCubit extends Cubit<RemoteArticlesState> {
  final GetArticlesUseCase _getArticlesUseCase;
  final LikeArticleUseCase _likeArticleUseCase;

  RemoteArticlesCubit(this._getArticlesUseCase, this._likeArticleUseCase)
      : super(const RemoteArticlesLoading());

  /// Fetches articles from the repository.
  /// Creates a shuffled copy for the 'For You' feed experience.
  Future<void> onGetArticles() async {
    emit(const RemoteArticlesLoading());

    final dataState = await _getArticlesUseCase();

    if (dataState is DataSuccess) {
      final originalList = dataState.data ?? [];
      final shuffledList = List<ArticleEntity>.from(originalList)..shuffle();
      emit(RemoteArticlesDone(originalList, feedArticles: shuffledList));
    }

    if (dataState is DataFailed) {
      emit(RemoteArticlesError(dataState.error!));
    }
  }

  /// Handles the 'Like' action with Optimistic UI.
  /// Updates the state immediately before the API call completes to ensure responsiveness.
  Future<void> onLikeArticle(ArticleEntity article) async {
    if (state is RemoteArticlesDone) {
      final currentState = state as RemoteArticlesDone;
      final currentArticles = currentState.articles!;
      final currentFeedArticles = currentState.feedArticles;

      final indexOriginal =
          currentArticles.indexWhere((a) => a.title == article.title);

      List<ArticleEntity> updatedOriginalList = List.from(currentArticles);
      ArticleEntity? updatedArticle;

      if (indexOriginal != -1) {
        final currentArticle = currentArticles[indexOriginal];
        updatedArticle = currentArticle.toggleLike(kUserId);
        updatedOriginalList[indexOriginal] = updatedArticle;
      }

      List<ArticleEntity> updatedFeedList = List.from(currentFeedArticles);
      if (updatedArticle != null) {
        final indexFeed =
            updatedFeedList.indexWhere((a) => a.title == updatedArticle!.title);
        if (indexFeed != -1) {
          updatedFeedList[indexFeed] = updatedArticle;
        }
      }

      emit(RemoteArticlesDone(updatedOriginalList,
          feedArticles: updatedFeedList));
    }

    await _likeArticleUseCase(params: ToggleLikeParams(article, kUserId));
  }
}
