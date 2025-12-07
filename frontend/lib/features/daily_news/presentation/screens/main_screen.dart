import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/remote/remote_article_cubit.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/pages/create_article/create_article_page.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/pages/profile/profile_page.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/screens/feed_screen.dart';
import 'package:news_app_clean_architecture/injection_container.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/navigation/navigation_service.dart';

/// The main container screen of the application.
/// Implements a Bottom Navigation Bar to switch between:
/// - Feed (Home)
/// - Create Article
/// - Profile
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  late final List<Widget> _pages;
  StreamSubscription? _tabSubscription;

  @override
  void initState() {
    super.initState();
    _pages = [
      const FeedScreen(),
      const CreateArticlePage(),
      const ProfilePage(),
    ];
    _tabSubscription = sl<NavigationService>().tabStream.listen((index) {
      if (mounted) {
        setState(() {
          _currentIndex = index;
        });
      }
    });
  }

  @override
  void dispose() {
    _tabSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          if (index == 0 && _currentIndex == 0) {
            context.read<RemoteArticlesCubit>().onGetArticles();
          }
          setState(() {
            _currentIndex = index;
          });
        },
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_filled),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline, size: 40),
            activeIcon: Icon(Icons.add_circle, size: 40),
            label: 'Crear',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}
