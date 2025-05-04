import 'package:intl/intl.dart';
import '../constants/app_constants.dart';

/// Tarih formatlama yardımcı sınıfı
class DateFormatter {
  /// Tarihi dd.MM.yyyy formatında göster (ör: 05.06.2023)
  static String formatDate(DateTime? date) {
    if (date == null) return '';
    return DateFormat(AppConstants.dateFormatDisplay).format(date);
  }

  /// Tarihi ve saati dd.MM.yyyy HH:mm formatında göster (ör: 05.06.2023 15:30)
  static String formatDateTime(DateTime? dateTime) {
    if (dateTime == null) return '';
    return DateFormat(AppConstants.dateTimeFormatDisplay).format(dateTime);
  }

  /// String'den DateTime oluştur (dd.MM.yyyy formatından)
  static DateTime? parseDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return null;
    try {
      return DateFormat(AppConstants.dateFormatDisplay).parse(dateStr);
    } catch (e) {
      return null;
    }
  }

  /// Tarihi yaşa çevir
  static int calculateAge(DateTime birthDate) {
    final today = DateTime.now();
    int age = today.year - birthDate.year;
    if (today.month < birthDate.month || 
        (today.month == birthDate.month && today.day < birthDate.day)) {
      age--;
    }
    return age;
  }

  /// İki tarih arasındaki gün farkını hesapla
  static int daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return (to.difference(from).inHours / 24).round();
  }

  /// Belirli bir tarihe kalan gün sayısını hesapla
  static int daysUntil(DateTime? date) {
    if (date == null) return 0;
    
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final targetDate = DateTime(date.year, date.month, date.day);
    
    if (targetDate.isBefore(today)) return 0;
    return daysBetween(today, targetDate);
  }

  /// Kalan gün sayısını metin olarak formatla
  static String formatRemainingDays(int days) {
    if (days <= 0) {
      return 'Süresi doldu';
    } else if (days == 1) {
      return '1 gün kaldı';
    } else {
      return '$days gün kaldı';
    }
  }

  /// Geçen süreyi metin olarak formatla
  static String formatTimeAgo(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays > 365) {
      final years = (difference.inDays / 365).floor();
      return '$years yıl önce';
    } else if (difference.inDays > 30) {
      final months = (difference.inDays / 30).floor();
      return '$months ay önce';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} gün önce';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} saat önce';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} dakika önce';
    } else {
      return 'az önce';
    }
  }
}