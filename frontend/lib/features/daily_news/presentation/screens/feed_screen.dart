import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/remote/remote_article_cubit.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/remote/remote_article_state.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/entities/article.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/widgets/feed_item.dart';
import 'package:news_app_clean_architecture/injection_container.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/navigation/navigation_service.dart';

/// Screen responsible for displaying the vertical news feed.
/// Uses [PageView] for a TikTok-like scrolling experience.
/// Listens to [RemoteArticlesCubit] for state changes.
class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  final PageController _pageController = PageController();
  StreamSubscription? _scrollSubscription;

  @override
  void initState() {
    super.initState();
    _scrollSubscription =
        sl<NavigationService>().feedScrollStream.listen((article) {
      if (mounted) {
        final state = context.read<RemoteArticlesCubit>().state;
        if (state is RemoteArticlesDone) {
          final index = state.feedArticles
              .indexWhere((element) => element.title == article.title);
          if (index != -1) {
            _pageController.jumpToPage(index);
          }
        }
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _scrollSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        forceMaterialTransparency: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white, size: 30),
            onPressed: () async {
              final result = await Navigator.pushNamed(context, '/SearchNews');
              if (!mounted) return;

              if (result != null && result is ArticleEntity) {
                final state = context.read<RemoteArticlesCubit>().state;
                if (state is RemoteArticlesDone) {
                  final index = state.feedArticles
                      .indexWhere((element) => element.title == result.title);
                  if (index != -1) {
                    _pageController.jumpToPage(index);
                  }
                }
              }
            },
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: BlocBuilder<RemoteArticlesCubit, RemoteArticlesState>(
        builder: (_, state) {
          if (state is RemoteArticlesLoading) {
            return const Center(
                child: CupertinoActivityIndicator(color: Colors.white));
          }

          if (state is RemoteArticlesError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  "Error: ${state.error?.message ?? state.error?.response?.statusMessage ?? "Unknown error"}\n\nDetails: ${state.error?.response?.data ?? ''}",
                  style: const TextStyle(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          if (state is RemoteArticlesDone) {
            if (state.articles == null || state.articles!.isEmpty) {
              return const Center(
                  child: Text("No hay noticias hoy",
                      style: TextStyle(color: Colors.white)));
            }

            return ScrollConfiguration(
              behavior:
                  ScrollConfiguration.of(context).copyWith(scrollbars: false),
              child: PageView.builder(
                controller: _pageController,
                scrollDirection: Axis.vertical,
                itemCount: state.feedArticles.length,
                itemBuilder: (context, index) {
                  return FeedItem(
                    article: state.feedArticles[index],
                    onLikePressed: (article) {
                      context
                          .read<RemoteArticlesCubit>()
                          .onLikeArticle(article);
                    },
                  );
                },
              ),
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}
