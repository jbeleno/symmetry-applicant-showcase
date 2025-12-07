import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/screens/feed_screen.dart';

/// Wrapper widget for the main news feed.
/// Currently delegates directly to [FeedScreen].
class DailyNews extends StatelessWidget {
  const DailyNews({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // This screen now acts as a gateway or can hold the BlocProvider
    // for the new UI. For now, we'll just display the FeedScreen.
    return const FeedScreen();
  }
}
