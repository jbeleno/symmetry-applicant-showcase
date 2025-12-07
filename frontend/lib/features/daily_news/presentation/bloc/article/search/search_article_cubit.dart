import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app_clean_architecture/core/resources/data_state.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/usecases/search_articles.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/search/search_article_state.dart';
import 'package:rxdart/rxdart.dart';

/// Manages the state of article search.
/// Implements debouncing to optimize API calls during typing.
class SearchArticleCubit extends Cubit<SearchArticleState> {
  final SearchArticlesUseCase _searchArticlesUseCase;
  final _searchSubject = PublishSubject<String>();

  SearchArticleCubit(this._searchArticlesUseCase)
      : super(const SearchArticleInitial()) {
    // Debounce search input to avoid spamming the API
    _searchSubject
        .debounceTime(const Duration(milliseconds: 500))
        .listen((query) {
      _search(query);
    });
    _search('');
  }

  /// Called when the user types in the search bar.
  void onSearchInputChanged(String query) {
    _searchSubject.add(query);
  }

  Future<void> _search(String query) async {
    emit(const SearchArticleLoading());
    final dataState = await _searchArticlesUseCase(params: query);

    if (dataState is DataSuccess && dataState.data!.isNotEmpty) {
      emit(SearchArticleDone(dataState.data!));
    } else if (dataState is DataFailed) {
      emit(SearchArticleError(dataState.error!));
    } else {
      emit(const SearchArticleInitial());
    }
  }

  @override
  Future<void> close() {
    _searchSubject.close();
    return super.close();
  }
}
