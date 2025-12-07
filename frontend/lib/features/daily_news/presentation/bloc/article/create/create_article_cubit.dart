import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app_clean_architecture/core/constants/constants.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/entities/article.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/usecases/create_article.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/usecases/update_article.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/usecases/delete_article.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/create/create_article_state.dart';

/// Manages the state for creating, updating, and deleting articles.
/// Handles form validation and interaction with the respective use cases.
class CreateArticleCubit extends Cubit<CreateArticleState> {
  final CreateArticleUseCase _createArticleUseCase;
  final UpdateArticleUseCase _updateArticleUseCase;
  final DeleteArticleUseCase _deleteArticleUseCase;

  CreateArticleCubit(this._createArticleUseCase, this._updateArticleUseCase,
      this._deleteArticleUseCase)
      : super(CreateArticleInitial());

  /// Validates input and creates a new article.
  ///
  /// [title], [description], and [content] are required.
  /// [image] is optional but recommended for better engagement.
  Future<void> submitArticle({
    required String title,
    required String description,
    required String content,
    String? url,
    File? image,
  }) async {
    if (title.isEmpty || content.isEmpty || description.isEmpty) {
      emit(const CreateArticleError(
          "El título, la descripción y el contenido son obligatorios"));
      return;
    }

    emit(CreateArticleLoading());

    try {
      final id = DateTime.now().millisecondsSinceEpoch.toString();

      final article = ArticleEntity(
        id: id,
        title: title,
        description: description,
        content: content,
        thumbnailUrl: '',
        publishedAt: DateTime.now(),
        authorId: kUserId,
        authorName: 'Usuario Local',
        authorAvatar: '',
        category: 'General',
        url: url,
        likes: 0,
      );

      await _createArticleUseCase(
        params: CreateArticleParams(article: article, image: image),
      );

      emit(CreateArticleSuccess());
    } catch (e) {
      emit(CreateArticleError(e.toString()));
    }
  }

  /// Updates an existing article with new data.
  Future<void> updateArticle({
    required ArticleEntity originalArticle,
    required String title,
    required String description,
    required String content,
    String? url,
    File? image,
  }) async {
    if (title.isEmpty || content.isEmpty || description.isEmpty) {
      emit(const CreateArticleError(
          "El título, la descripción y el contenido son obligatorios"));
      return;
    }

    emit(CreateArticleLoading());

    try {
      final updatedArticle = originalArticle.copyWith(
        title: title,
        description: description,
        content: content,
        url: url,
      );

      await _updateArticleUseCase(
        params: UpdateArticleParams(article: updatedArticle, image: image),
      );

      emit(CreateArticleSuccess());
    } catch (e) {
      emit(CreateArticleError(e.toString()));
    }
  }

  /// Deletes an article permanently.
  Future<void> deleteArticle(ArticleEntity article) async {
    emit(CreateArticleLoading());
    try {
      await _deleteArticleUseCase(params: article);
      emit(CreateArticleSuccess());
    } catch (e) {
      emit(CreateArticleError(e.toString()));
    }
  }
}
