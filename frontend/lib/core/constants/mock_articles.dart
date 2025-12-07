import '../../features/daily_news/domain/entities/article.dart';

final now = DateTime.now();

final List<ArticleEntity> kMockArticles = [
  ArticleEntity(
    id: '1',
    title: 'The Future of AI: Trends to Watch in 2025',
    content:
        'From large language models to autonomous systems, AI is evolving at an unprecedented pace...',
    category: 'Technology',
    thumbnailUrl:
        'https://images.unsplash.com/photo-1485827404703-89b55fcc595e?q=80&w=1200&auto=format&fit=crop',
    publishedAt: now,
    authorName: 'Jane Doe',
    authorAvatar: 'https://i.pravatar.cc/150?u=jane_doe',
    likes: 1200,
  ),
  ArticleEntity(
    id: '2',
    title: 'Breakthrough in Quantum Computing Announced',
    content: 'Scientists have made a significant leap in quantum computing...',
    category: 'Science',
    thumbnailUrl:
        'https://images.unsplash.com/photo-1635070041078-e363dbe005cb?q=80&w=1200&auto=format&fit=crop',
    publishedAt: now.subtract(const Duration(days: 1)),
    authorName: 'John Smith',
    authorAvatar: 'https://i.pravatar.cc/150?u=john_smith',
    likes: 2500,
  ),
  ArticleEntity(
    id: '3',
    title: 'Global Markets React to New Economic Policies',
    content: 'An in-depth analysis of how the latest economic policies...',
    category: 'Business',
    thumbnailUrl:
        'https://images.unsplash.com/photo-1611974765270-ca1258634369?q=80&w=1200&auto=format&fit=crop',
    publishedAt: now.subtract(const Duration(days: 2)),
    authorName: 'Emily Jones',
    authorAvatar: 'https://i.pravatar.cc/150?u=emily_jones',
    likes: 850,
  ),
  ArticleEntity(
    id: '4',
    title: 'Champions League Finals: A Match to Remember',
    content:
        'A thrilling recap of the final match, complete with highlights...',
    category: 'Sports',
    thumbnailUrl:
        'https://images.unsplash.com/photo-1579952363873-27f3bade9f55?q=80&w=1200&auto=format&fit=crop',
    publishedAt: now.subtract(const Duration(days: 3)),
    authorName: 'Mike Brown',
    authorAvatar: 'https://i.pravatar.cc/150?u=mike_brown',
    likes: 5300,
  ),
  ArticleEntity(
    id: '5',
    title: 'The Rise of Personalized Medicine',
    content: 'How tailored medical treatments are changing healthcare...',
    category: 'Health',
    thumbnailUrl:
        'https://images.unsplash.com/photo-1576091160399-112ba8d25d1d?q=80&w=1200&auto=format&fit=crop',
    publishedAt: now.subtract(const Duration(days: 4)),
    authorName: 'Dr. Sarah Wilson',
    authorAvatar: 'https://i.pravatar.cc/150?u=sarah_wilson',
    likes: 3100,
  ),
];
