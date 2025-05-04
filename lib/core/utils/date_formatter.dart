import 'package:intl/intl.dart';
import '../constants/app_constants.dart';

class DateFormatter {
  // DateTime'ı Türkçe formatlı string olarak döndürür (ör: 01.01.2023)
  static String formatDate(DateTime? date) {
    if (date == null) return '';
    return DateFormat(AppConstants.dateFormat).format(date);
  }
  
  // DateTime nesnesini gün adıyla birlikte döndürür (ör: 01.01.2023 Pazartesi)
  static String formatDateWithDay(DateTime? date) {
    if (date == null) return '';
    final weekdays = ['Pazartesi', 'Salı', 'Çarşamba', 'Perşembe', 'Cuma', 'Cumartesi', 'Pazar'];
    final dayName = weekdays[date.weekday - 1];
    return '${formatDate(date)} $dayName';
  }
  
  // String'i DateTime nesnesine dönüştürür
  static DateTime? parseDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return null;
    try {
      return DateFormat(AppConstants.dateFormat).parse(dateStr);
    } catch (e) {
      return null;
    }
  }
  
  // Tarih ve saat formatı (ör: 01.01.2023 14:30)
  static String formatDateTime(DateTime? dateTime) {
    if (dateTime == null) return '';
    return DateFormat('${AppConstants.dateFormat} HH:mm').format(dateTime);
  }
  
  // Ay ve yıl formatı (ör: Ocak 2023)
  static String formatMonthYear(DateTime? date) {
    if (date == null) return '';
    
    final months = [
      'Ocak', 'Şubat', 'Mart', 'Nisan', 'Mayıs', 'Haziran',
      'Temmuz', 'Ağustos', 'Eylül', 'Ekim', 'Kasım', 'Aralık'
    ];
    
    return '${months[date.month - 1]} ${date.year}';
  }
  
  // İki tarih arasındaki gün farkı
  static int daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return (to.difference(from).inHours / 24).round();
  }
  
  // Kalan gün sayısını formatla (pozitif, negatif veya 0)
  static String formatRemainingDays(int days) {
    if (days > 0) {
      return '$days gün kaldı';
    } else if (days < 0) {
      return '${days.abs()} gün geçti';
    } else {
      return 'Bugün son gün';
    }
  }
}