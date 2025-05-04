import 'package:flutter/material.dart';

/// SnackBar göstermek için yardımcı sınıf
class SnackbarHelper {
  /// Başarı mesajı içeren SnackBar gösterir
  static void showSuccessSnackBar(BuildContext context, String message) {
    _showSnackBar(
      context: context,
      message: message,
      backgroundColor: Colors.green.shade800,
      icon: Icons.check_circle,
    );
  }
  
  /// Hata mesajı içeren SnackBar gösterir
  static void showErrorSnackBar(BuildContext context, String message) {
    _showSnackBar(
      context: context,
      message: message,
      backgroundColor: Colors.red.shade800,
      icon: Icons.error,
    );
  }
  
  /// Bilgi mesajı içeren SnackBar gösterir
  static void showInfoSnackBar(BuildContext context, String message) {
    _showSnackBar(
      context: context,
      message: message,
      backgroundColor: Colors.blue.shade800,
      icon: Icons.info,
    );
  }
  
  /// Uyarı mesajı içeren SnackBar gösterir
  static void showWarningSnackBar(BuildContext context, String message) {
    _showSnackBar(
      context: context,
      message: message,
      backgroundColor: Colors.orange.shade800,
      icon: Icons.warning,
    );
  }
  
  /// SnackBar göstermek için kullanılan temel metot
  static void _showSnackBar({
    required BuildContext context,
    required String message,
    required Color backgroundColor,
    required IconData icon,
    Duration duration = const Duration(seconds: 3),
  }) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        duration: duration,
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        margin: const EdgeInsets.all(8),
        action: SnackBarAction(
          label: 'Tamam',
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }
}