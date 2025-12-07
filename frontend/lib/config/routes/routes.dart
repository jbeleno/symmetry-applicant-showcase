import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/search/search_article_cubit.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/pages/search/search_news_page.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/screens/main_screen.dart';
import 'package:news_app_clean_architecture/injection_container.dart';

import '../../features/daily_news/domain/entities/article.dart';
import '../../features/daily_news/presentation/pages/saved_article/saved_article.dart';
import '../../features/daily_news/presentation/pages/create_article/create_article_page.dart';

class AppRoutes {
  static Route onGenerateRoutes(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return _materialRoute(const MainScreen());

      case '/SearchNews':
        return _materialRoute(BlocProvider<SearchArticleCubit>(
          create: (context) => sl<SearchArticleCubit>(),
          child: const SearchNewsPage(),
        ));

      case '/SavedArticles':
        return _materialRoute(const SavedArticles());

      case '/CreateArticle':
        return _materialRoute(
            CreateArticlePage(article: settings.arguments as ArticleEntity?));

      default:
        return _materialRoute(const MainScreen());
    }
  }

  static Route<dynamic> _materialRoute(Widget view) {
    return MaterialPageRoute(builder: (_) => view);
  }
}
