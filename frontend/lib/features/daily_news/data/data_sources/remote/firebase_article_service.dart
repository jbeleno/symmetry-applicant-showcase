import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:news_app_clean_architecture/features/daily_news/data/models/article.dart';

/// Service responsible for all Firebase interactions (Firestore & Storage).
/// Handles CRUD operations for articles and image uploads.
class FirebaseArticleService {
  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;

  FirebaseArticleService(this._firestore, this._storage);

  /// Uploads an image to Firebase Storage and returns the download URL.
  /// Includes a 20-second timeout to prevent hanging requests.
  Future<String> uploadImage(File image) async {
    try {
      final ref = _storage
          .ref()
          .child('article_images/${DateTime.now().millisecondsSinceEpoch}.jpg');

      final bytes = await image.readAsBytes();
      final metadata = SettableMetadata(contentType: 'image/jpeg');

      final uploadTask = ref.putData(bytes, metadata);

      final snapshot = await uploadTask.timeout(
        const Duration(seconds: 20),
        onTimeout: () {
          uploadTask.cancel().catchError((e) {
            print(
                "⚠️ La tarea no se pudo cancelar (probablemente nunca inició): $e");
            return true;
          });
          throw Exception(
              "La subida de imagen tardó demasiado. Revisa tu conexión.");
        },
      );

      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      throw Exception("Error subiendo imagen: $e");
    }
  }

  /// Retrieves all articles from the 'articles' collection in Firestore.
  Future<List<ArticleModel>> getArticles() async {
    final snapshot = await _firestore.collection('articles').get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      final stats = data['stats'] as Map<String, dynamic>? ?? {};
      final author = data['author'] as Map<String, dynamic>? ?? {};
      final likedBy = List<String>.from(data['liked_by'] ?? []);

      return ArticleModel(
        id: doc.id,
        title: data['title'] ?? '',
        description: data['description'] ?? '',
        content: data['content'] ?? '',
        category: data['category'] ?? 'General',
        thumbnailUrl: data['thumbnailUrl'] ?? data['urlToImage'] ?? '',
        publishedAt:
            DateTime.tryParse(data['publishedAt'] ?? '') ?? DateTime.now(),
        authorId: author['id'],
        authorName: author['name'] ?? 'Unknown',
        authorAvatar: author['avatar'] ?? '',
        likes: stats['likes'] ?? 0,
        likedIds: likedBy,
      );
    }).toList();
  }

  /// Creates a new article document in Firestore.
  Future<void> createArticle(ArticleModel article) async {
    final docRef = _firestore.collection('articles').doc(article.id);
    await docRef.set({
      'title': article.title,
      'description': article.description,
      'content': article.content,
      'category': article.category,
      'thumbnailUrl': article.thumbnailUrl,
      'publishedAt': article.publishedAt.toIso8601String(),
      'author': {
        'id': article.authorId,
        'name': article.authorName,
        'avatar': article.authorAvatar,
      },
      'stats': {
        'likes': 0,
      },
      'liked_by': [],
    });
  }

  /// Updates an existing article document.
  Future<void> updateArticle(ArticleModel article) async {
    final docRef = _firestore.collection('articles').doc(article.id);
    await docRef.update({
      'title': article.title,
      'description': article.description,
      'content': article.content,
      'thumbnailUrl': article.thumbnailUrl,
    });
  }

  /// Deletes an article document.
  Future<void> deleteArticle(String articleId) async {
    await _firestore.collection('articles').doc(articleId).delete();
  }

  /// Toggles the like status of an article.
  /// If the article doesn't exist in Firestore (e.g. it's from NewsAPI), it creates it first.
  /// Uses atomic increments for the like count.
  Future<void> toggleLike(String articleId, String userId,
      {ArticleModel? article}) async {
    if (articleId.isEmpty && article != null) {
      final generatedId = DateTime.now().millisecondsSinceEpoch.toString();
      final docRef = _firestore.collection('articles').doc(generatedId);

      await docRef.set({
        'title': article.title,
        'description': article.description,
        'content': article.content,
        'category': article.category,
        'thumbnailUrl': article.thumbnailUrl,
        'publishedAt': article.publishedAt.toIso8601String(),
        'author': {
          'name': article.authorName,
          'avatar': article.authorAvatar,
        },
        'stats': {
          'likes': 1,
        },
        'liked_by': [userId],
      });
      return;
    }

    final docRef = _firestore.collection('articles').doc(articleId);
    final doc = await docRef.get();

    if (doc.exists) {
      final data = doc.data() as Map<String, dynamic>;
      final likedBy = List<String>.from(data['liked_by'] ?? []);

      if (likedBy.contains(userId)) {
        await docRef.update({
          'liked_by': FieldValue.arrayRemove([userId]),
          'stats.likes': FieldValue.increment(-1),
        });
      } else {
        await docRef.update({
          'liked_by': FieldValue.arrayUnion([userId]),
          'stats.likes': FieldValue.increment(1),
        });
      }
    } else if (article != null) {
      await docRef.set({
        'title': article.title,
        'description': article.content,
        'content': article.content,
        'category': article.category,
        'thumbnailUrl': article.thumbnailUrl,
        'publishedAt': article.publishedAt.toIso8601String(),
        'author': {
          'name': article.authorName,
          'avatar': article.authorAvatar,
        },
        'stats': {
          'likes': 1,
        },
        'liked_by': [userId],
      });
    }
  }

  /// Saves an article to Firestore (Alternative to local bookmarking).
  Future<void> saveArticle(ArticleModel article) async {
    final docRef = _firestore.collection('articles').doc(article.id);
    final docSnapshot = await docRef.get();

    if (docSnapshot.exists) {
      await docRef.update({
        'stats.likes': FieldValue.increment(1),
      });
    } else {
      await docRef.set({
        'title': article.title,
        'description': article.description,
        'content': article.content,
        'category': article.category,
        'thumbnailUrl': article.thumbnailUrl,
        'publishedAt': article.publishedAt.toIso8601String(),
        'author': {
          'name': article.authorName,
          'avatar': article.authorAvatar,
        },
        'stats': {
          'likes': 1,
        }
      });
    }
  }
}
