import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:news_app_clean_architecture/features/daily_news/data/data_sources/remote/firebase_article_service.dart';
import 'package:news_app_clean_architecture/features/daily_news/data/data_sources/remote/news_remote_data_source.dart';
import 'package:news_app_clean_architecture/features/daily_news/data/repository/article_repository_impl.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/repository/article_repository.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/usecases/get_articles.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/remote/remote_article_cubit.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/usecases/like_article.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/usecases/search_articles.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/search/search_article_cubit.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/usecases/create_article.dart';
import 'features/daily_news/data/data_sources/local/app_database.dart';
import 'features/daily_news/domain/usecases/get_saved_article.dart';
import 'features/daily_news/domain/usecases/remove_article.dart';
import 'features/daily_news/domain/usecases/save_article.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/create/create_article_cubit.dart';
import 'features/daily_news/presentation/bloc/article/local/local_article_bloc.dart';
import 'package:floor/floor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'config/theme/theme_cubit.dart';
import 'features/daily_news/presentation/bloc/profile/profile_cubit.dart';

import 'package:news_app_clean_architecture/features/daily_news/domain/usecases/update_article.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/navigation/navigation_service.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/usecases/delete_article.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/repository/profile_repository.dart';
import 'package:news_app_clean_architecture/features/daily_news/data/repository/profile_repository_impl.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/usecases/get_profile.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/usecases/update_profile.dart';
import 'package:news_app_clean_architecture/features/settings/domain/repository/settings_repository.dart';
import 'package:news_app_clean_architecture/features/settings/data/repository/settings_repository_impl.dart';
import 'package:news_app_clean_architecture/features/settings/domain/usecases/get_theme.dart';
import 'package:news_app_clean_architecture/features/settings/domain/usecases/save_theme.dart';

/// Service Locator instance using GetIt.
final sl = GetIt.instance;

/// Initializes all dependencies for the application.
/// Registers Singletons and Factories for Clean Architecture layers:
/// - External (Firebase, Dio, DB)
/// - Data Sources
/// - Repositories
/// - Use Cases
/// - BLoCs / Cubits
Future<void> initializeDependencies() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerSingleton<SharedPreferences>(sharedPreferences);

  // Navigation Service
  sl.registerSingleton<NavigationService>(NavigationService());

  // Database Migrations
  final migration1to2 = Migration(1, 2, (database) async {
    await database.execute(
        'ALTER TABLE article ADD COLUMN description TEXT NOT NULL DEFAULT ""');
  });

  final migration2to3 = Migration(2, 3, (database) async {
    await database.execute('ALTER TABLE article ADD COLUMN url TEXT');
  });

  final database = await $FloorAppDatabase
      .databaseBuilder('app_database.db')
      .addMigrations([migration1to2, migration2to3]).build();
  sl.registerSingleton<AppDatabase>(database);

  // Dio Client for REST API
  sl.registerSingleton<Dio>(Dio());

  // --- Data Layer ---
  // Data Sources
  sl.registerSingleton<FirebaseArticleService>(FirebaseArticleService(
    FirebaseFirestore.instance,
    FirebaseStorage.instance,
  ));
  sl.registerSingleton<NewsRemoteDataSource>(NewsRemoteDataSource(sl()));

  // Repositories
  sl.registerSingleton<ArticleRepository>(
      ArticleRepositoryImpl(sl(), sl(), sl()));
  sl.registerSingleton<ProfileRepository>(ProfileRepositoryImpl(sl()));
  sl.registerSingleton<SettingsRepository>(SettingsRepositoryImpl(sl()));

  // --- Domain Layer (UseCases) ---
  sl.registerSingleton<GetArticlesUseCase>(GetArticlesUseCase(sl()));
  sl.registerSingleton<SearchArticlesUseCase>(SearchArticlesUseCase(sl()));
  sl.registerSingleton<LikeArticleUseCase>(LikeArticleUseCase(sl()));

  sl.registerSingleton<GetSavedArticleUseCase>(GetSavedArticleUseCase(sl()));

  sl.registerSingleton<SaveArticleUseCase>(SaveArticleUseCase(sl()));

  sl.registerSingleton<RemoveArticleUseCase>(RemoveArticleUseCase(sl()));
  sl.registerSingleton<CreateArticleUseCase>(CreateArticleUseCase(sl()));
  sl.registerSingleton<UpdateArticleUseCase>(UpdateArticleUseCase(sl()));
  sl.registerSingleton<DeleteArticleUseCase>(DeleteArticleUseCase(sl()));
  sl.registerSingleton<GetProfileUseCase>(GetProfileUseCase(sl()));
  sl.registerSingleton<UpdateProfileUseCase>(UpdateProfileUseCase(sl()));
  sl.registerSingleton<GetThemeUseCase>(GetThemeUseCase(sl()));
  sl.registerSingleton<SaveThemeUseCase>(SaveThemeUseCase(sl()));

  // --- Presentation Layer (BLoCs) ---
  sl.registerFactory<RemoteArticlesCubit>(
      () => RemoteArticlesCubit(sl(), sl()));
  sl.registerFactory<SearchArticleCubit>(() => SearchArticleCubit(sl()));
  sl.registerFactory<CreateArticleCubit>(
      () => CreateArticleCubit(sl(), sl(), sl()));
  sl.registerFactory<ThemeCubit>(() => ThemeCubit(sl(), sl()));
  sl.registerFactory<ProfileCubit>(() => ProfileCubit(sl(), sl()));

  sl.registerFactory<LocalArticleBloc>(
      () => LocalArticleBloc(sl(), sl(), sl()));
}
