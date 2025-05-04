import 'package:flutter/material.dart';

/// Uygulama genelinde kullanılan renk sabitleri
class ColorConstants {
  // Temel renkler
  static const Color primaryRed = Color(0xFFE53935);
  static const Color secondaryBlue = Color(0xFF1E88E5);
  static const Color accentYellow = Color(0xFFFFD600);
  
  // Tema renkleri - Koyu
  static const Color backgroundBlack = Color(0xFF121212);
  static const Color surfaceBlack = Color(0xFF1E1E1E);
  static const Color cardBlack = Color(0xFF2D2D2D);
  
  // Tema renkleri - Aydınlık (İleride kullanılacak)
  static const Color backgroundWhite = Color(0xFFF5F5F5);
  static const Color surfaceWhite = Color(0xFFFFFFFF);
  static const Color cardWhite = Color(0xFFFFFFFF);
  
  // Metin renkleri
  static const Color textWhite = Color(0xFFEEEEEE);
  static const Color textGrey = Color(0xFF9E9E9E);
  static const Color textBlack = Color(0xFF212121);
  
  // Durum renkleri
  static const Color statusActive = Color(0xFF4CAF50);    // Aktif - Yeşil
  static const Color statusWarning = Color(0xFFFFA000);   // Uyarı - Turuncu
  static const Color statusError = Color(0xFFF44336);     // Hata - Kırmızı
  static const Color statusInactive = Color(0xFF757575);  // Pasif - Gri
  
  // Ayırıcı çizgiler
  static const Color dividerColor = Color(0xFF424242);
  
  // Gölgeler ve ikonlar
  static const Color shadowColor = Color(0x40000000); // %25 opak siyah
  static const Color iconColor = Color(0xFFBDBDBD);
  
  // Ödeme durumu renkleri
  static const Color paymentPaid = Color(0xFF4CAF50);     // Ödendi - Yeşil
  static const Color paymentPartial = Color(0xFFFFA000);  // Kısmi ödeme - Turuncu
  static const Color paymentPending = Color(0xFF2196F3);  // Beklemede - Mavi
  static const Color paymentRefunded = Color(0xFFF44336); // İade edildi - Kırmızı
  
  // Grafik renkleri
  static const List<Color> chartColors = [
    Color(0xFFE53935), // Kırmızı
    Color(0xFF1E88E5), // Mavi
    Color(0xFF43A047), // Yeşil
    Color(0xFFFFB300), // Sarı
    Color(0xFF8E24AA), // Mor
    Color(0xFF0097A7), // Turkuaz
    Color(0xFFF4511E), // Turuncu
    Color(0xFF546E7A), // Gri-Mavi
  ];
  
  // Gradient renkler
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFE53935), // Kırmızı başlangıç
      Color(0xFFC62828), // Kırmızı bitiş
    ],
  );
  
  static const LinearGradient secondaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF1E88E5), // Mavi başlangıç
      Color(0xFF1565C0), // Mavi bitiş
    ],
  );
}