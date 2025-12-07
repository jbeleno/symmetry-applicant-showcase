import 'package:floor/floor.dart';
import 'package:news_app_clean_architecture/features/daily_news/data/data_sources/local/DAO/article_dao.dart';
import '../../models/article.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'dart:async';
import 'dart:convert';
part 'app_database.g.dart';

/// Type converter for storing [DateTime] as integer (milliseconds since epoch).
class DateTimeConverter extends TypeConverter<DateTime, int> {
  @override
  DateTime decode(int databaseValue) {
    return DateTime.fromMillisecondsSinceEpoch(databaseValue);
  }

  @override
  int encode(DateTime value) {
    return value.millisecondsSinceEpoch;
  }
}

/// Type converter for storing [List<String>] as a JSON string.
class StringListConverter extends TypeConverter<List<String>, String> {
  @override
  List<String> decode(String databaseValue) {
    return List<String>.from(json.decode(databaseValue));
  }

  @override
  String encode(List<String> value) {
    return json.encode(value);
  }
}

/// Main database configuration for Floor.
/// Defines entities and type converters.
@TypeConverters([DateTimeConverter, StringListConverter])
@Database(version: 3, entities: [ArticleModel])
abstract class AppDatabase extends FloorDatabase {
  /// Data Access Object for Articles.
  ArticleDao get articleDAO;
}
