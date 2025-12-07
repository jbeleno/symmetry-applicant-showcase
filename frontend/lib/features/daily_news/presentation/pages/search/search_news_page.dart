import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/search/search_article_cubit.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/search/search_article_state.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/widgets/feed_item.dart';

/// Page responsible for searching news articles.
/// Uses [SearchArticleCubit] to handle search logic and state.
class SearchNewsPage extends HookWidget {
  const SearchNewsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final searchController = useTextEditingController();
    useListenable(searchController);

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: searchController,
          style: Theme.of(context).textTheme.bodyLarge,
          decoration: InputDecoration(
            hintText: 'Buscar noticias...',
            border: InputBorder.none,
            hintStyle: Theme.of(context).inputDecorationTheme.hintStyle,
          ),
          onChanged: (value) {
            context.read<SearchArticleCubit>().onSearchInputChanged(value);
          },
        ),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        iconTheme: Theme.of(context).appBarTheme.iconTheme,
        elevation: 0,
      ),
      body: _buildBody(context, searchController.text),
    );
  }

  Widget _buildBody(BuildContext context, String query) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Text(
              query.isEmpty ? "Lo último en vivo" : "Búsquedas para '$query'",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
            ),
          ),
          Expanded(
            child: BlocBuilder<SearchArticleCubit, SearchArticleState>(
              builder: (context, state) {
                if (state is SearchArticleLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is SearchArticleError) {
                  return const Center(child: Icon(Icons.refresh));
                }
                if (state is SearchArticleDone) {
                  if (state.articles!.isEmpty) {
                    return Center(
                      child: Text(
                        "No se encontraron resultados.",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    );
                  }
                  return ListView.builder(
                    itemCount: state.articles!.length,
                    itemBuilder: (context, index) {
                      return FeedItem(
                        article: state.articles![index],
                        isList: true,
                        onArticlePressed: (article) {
                          Navigator.pop(context, article);
                        },
                      );
                    },
                  );
                }
                return const SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }
}
