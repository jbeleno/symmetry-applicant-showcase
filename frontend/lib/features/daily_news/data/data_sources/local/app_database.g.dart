part of 'app_database.dart';

abstract class $AppDatabaseBuilderContract {
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations);

  $AppDatabaseBuilderContract addCallback(Callback callback);

  Future<AppDatabase> build();
}

class $FloorAppDatabase {
  static $AppDatabaseBuilderContract databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  static $AppDatabaseBuilderContract inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder implements $AppDatabaseBuilderContract {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  @override
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  @override
  $AppDatabaseBuilderContract addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  @override
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  ArticleDao? _articleDAOInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 3,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `article` (`id` TEXT NOT NULL, `title` TEXT NOT NULL, `description` TEXT NOT NULL, `content` TEXT NOT NULL, `category` TEXT NOT NULL, `thumbnailUrl` TEXT NOT NULL, `publishedAt` INTEGER NOT NULL, `authorId` TEXT, `authorName` TEXT NOT NULL, `authorAvatar` TEXT NOT NULL, `url` TEXT, `likes` INTEGER NOT NULL, `likedIds` TEXT NOT NULL, PRIMARY KEY (`id`))');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  ArticleDao get articleDAO {
    return _articleDAOInstance ??= _$ArticleDao(database, changeListener);
  }
}

class _$ArticleDao extends ArticleDao {
  _$ArticleDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _articleModelInsertionAdapter = InsertionAdapter(
            database,
            'article',
            (ArticleModel item) => <String, Object?>{
                  'id': item.id,
                  'title': item.title,
                  'description': item.description,
                  'content': item.content,
                  'category': item.category,
                  'thumbnailUrl': item.thumbnailUrl,
                  'publishedAt': _dateTimeConverter.encode(item.publishedAt),
                  'authorId': item.authorId,
                  'authorName': item.authorName,
                  'authorAvatar': item.authorAvatar,
                  'url': item.url,
                  'likes': item.likes,
                  'likedIds': _stringListConverter.encode(item.likedIds)
                }),
        _articleModelDeletionAdapter = DeletionAdapter(
            database,
            'article',
            ['id'],
            (ArticleModel item) => <String, Object?>{
                  'id': item.id,
                  'title': item.title,
                  'description': item.description,
                  'content': item.content,
                  'category': item.category,
                  'thumbnailUrl': item.thumbnailUrl,
                  'publishedAt': _dateTimeConverter.encode(item.publishedAt),
                  'authorId': item.authorId,
                  'authorName': item.authorName,
                  'authorAvatar': item.authorAvatar,
                  'url': item.url,
                  'likes': item.likes,
                  'likedIds': _stringListConverter.encode(item.likedIds)
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<ArticleModel> _articleModelInsertionAdapter;

  final DeletionAdapter<ArticleModel> _articleModelDeletionAdapter;

  @override
  Future<List<ArticleModel>> getArticles() async {
    return _queryAdapter.queryList('SELECT * FROM article',
        mapper: (Map<String, Object?> row) => ArticleModel(
            id: row['id'] as String,
            title: row['title'] as String,
            description: row['description'] as String,
            content: row['content'] as String,
            category: row['category'] as String,
            thumbnailUrl: row['thumbnailUrl'] as String,
            publishedAt: _dateTimeConverter.decode(row['publishedAt'] as int),
            authorId: row['authorId'] as String?,
            authorName: row['authorName'] as String,
            authorAvatar: row['authorAvatar'] as String,
            url: row['url'] as String?,
            likes: row['likes'] as int,
            likedIds: _stringListConverter.decode(row['likedIds'] as String)));
  }

  @override
  Future<void> insertArticle(ArticleModel article) async {
    await _articleModelInsertionAdapter.insert(
        article, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteArticle(ArticleModel articleModel) async {
    await _articleModelDeletionAdapter.delete(articleModel);
  }
}

final _dateTimeConverter = DateTimeConverter();
final _stringListConverter = StringListConverter();
