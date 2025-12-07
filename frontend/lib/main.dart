import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app_clean_architecture/config/routes/routes.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/remote/remote_article_cubit.dart';
import 'config/theme/theme_cubit.dart';
import 'injection_container.dart';
import 'package:firebase_core/firebase_core.dart';

/// Entry point of the application.
/// Initializes Firebase and Dependency Injection before running the app.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await initializeDependencies();

  runApp(const MyApp());
}

/// Root widget of the application.
/// Sets up global providers (Theme, Articles) and routing.
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ThemeCubit>(
          create: (context) => sl<ThemeCubit>(),
        ),
        // Initialize RemoteArticlesCubit immediately to fetch data on startup
        BlocProvider<RemoteArticlesCubit>(
          create: (context) => sl<RemoteArticlesCubit>()..onGetArticles(),
        ),
      ],
      child: BlocBuilder<ThemeCubit, ThemeData>(
        builder: (context, theme) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: theme,
            onGenerateRoute: AppRoutes.onGenerateRoutes,
            initialRoute: '/',
          );
        },
      ),
    );
  }
}
