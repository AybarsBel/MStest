import 'package:intl/intl.dart';
import '../constants/app_constants.dart';

class DateUtil {
  static String formatDate(DateTime date) {
    return DateFormat(AppConstants.dateFormat).format(date);
  }

  static String formatDateTime(DateTime date) {
    return DateFormat(AppConstants.dateTimeFormat).format(date);
  }

  static DateTime parseDate(String dateStr) {
    return DateFormat(AppConstants.dateFormat).parse(dateStr);
  }

  static DateTime? tryParseDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) {
      return null;
    }
    try {
      return DateFormat(AppConstants.dateFormat).parse(dateStr);
    } catch (e) {
      return null;
    }
  }

  static int calculateRemainingDays(DateTime registrationDate) {
    // Kayıt tarihinden 1 ay sonrası
    final expiryDate = DateTime(
      registrationDate.year,
      registrationDate.month + AppConstants.defaultMembershipPeriodInMonths,
      registrationDate.day,
    );
    
    final today = DateTime.now();
    final difference = expiryDate.difference(today).inDays;
    
    return difference > 0 ? difference : 0;
  }

  static DateTime getExpiryDate(DateTime registrationDate) {
    return DateTime(
      registrationDate.year,
      registrationDate.month + AppConstants.defaultMembershipPeriodInMonths,
      registrationDate.day,
    );
  }

  static bool isExpired(DateTime registrationDate) {
    final expiryDate = getExpiryDate(registrationDate);
    final today = DateTime.now();
    return today.isAfter(expiryDate);
  }

  static bool isNearExpiry(DateTime registrationDate) {
    final remainingDays = calculateRemainingDays(registrationDate);
    return remainingDays <= AppConstants.reminderDays && remainingDays > 0;
  }

  static DateTime getFirstDayOfMonth(DateTime date) {
    return DateTime(date.year, date.month, 1);
  }

  static DateTime getLastDayOfMonth(DateTime date) {
    return DateTime(date.year, date.month + 1, 0);
  }

  static DateTime getFirstDayOfYear(DateTime date) {
    return DateTime(date.year, 1, 1);
  }

  static DateTime getLastDayOfYear(DateTime date) {
    return DateTime(date.year, 12, 31);
  }

  static List<DateTime> getMonthsInRange(DateTime start, DateTime end) {
    List<DateTime> months = [];
    DateTime current = DateTime(start.year, start.month, 1);
    
    while (current.isBefore(end) || current.year == end.year && current.month == end.month) {
      months.add(DateTime(current.year, current.month, 1));
      current = DateTime(current.year, current.month + 1, 1);
    }
    
    return months;
  }
}
