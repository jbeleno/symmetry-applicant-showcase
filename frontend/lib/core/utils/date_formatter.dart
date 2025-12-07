class DateFormatter {
  static String formatPublishedDate(DateTime? publishedAt) {
    if (publishedAt == null) return '';

    try {
      final publishedDate = publishedAt.toLocal();
      final now = DateTime.now();
      final difference = now.difference(publishedDate);

      if (difference.inMinutes < 1) {
        return 'Hace un momento';
      } else if (difference.inMinutes < 60) {
        return 'Hace ${difference.inMinutes} min';
      } else if (difference.inHours < 24) {
        return 'Hace ${difference.inHours} h';
      } else if (difference.inDays < 2) {
        return 'Ayer';
      } else {
        return '${publishedDate.day}/${publishedDate.month}/${publishedDate.year}';
      }
    } catch (e) {
      return '';
    }
  }
}
