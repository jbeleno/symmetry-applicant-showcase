import 'dart:async';
import 'package:news_app_clean_architecture/features/daily_news/domain/entities/article.dart';

/// Service responsible for handling cross-component navigation events.
/// Uses Streams to broadcast navigation requests (like tab switching or scrolling)
/// to listening widgets, decoupling the trigger from the action.
class NavigationService {
  final _tabController = StreamController<int>.broadcast();
  final _feedScrollController = StreamController<ArticleEntity>.broadcast();

  Stream<int> get tabStream => _tabController.stream;
  Stream<ArticleEntity> get feedScrollStream => _feedScrollController.stream;

  /// Requests a switch to the specified tab index.
  void switchTab(int index) {
    _tabController.sink.add(index);
  }

  /// Requests the feed to scroll to a specific article.
  void scrollToArticle(ArticleEntity article) {
    _feedScrollController.sink.add(article);
  }

  void dispose() {
    _tabController.close();
    _feedScrollController.close();
  }
}
