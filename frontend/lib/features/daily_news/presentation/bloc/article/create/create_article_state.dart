import 'package:equatable/equatable.dart';

/// Base state for the article creation, update, and deletion feature.
abstract class CreateArticleState extends Equatable {
  const CreateArticleState();

  @override
  List<Object> get props => [];
}

/// Initial state when the screen is first opened.
class CreateArticleInitial extends CreateArticleState {}

/// State indicating that an operation (create, update, delete) is in progress.
class CreateArticleLoading extends CreateArticleState {}

/// State indicating that the operation completed successfully.
class CreateArticleSuccess extends CreateArticleState {}

/// State indicating that an error occurred.
class CreateArticleError extends CreateArticleState {
  final String message;

  const CreateArticleError(this.message);

  @override
  List<Object> get props => [message];
}
