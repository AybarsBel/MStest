import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/color_constants.dart';

/// Uygulama tema ayarları
class AppTheme {
  // Sistem UI ayarları
  static void setSystemUIOverlayStyle(bool isDarkMode) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: isDarkMode ? Brightness.light : Brightness.dark,
        systemNavigationBarColor: isDarkMode ? ColorConstants.backgroundBlack : ColorConstants.backgroundWhite,
        systemNavigationBarIconBrightness: isDarkMode ? Brightness.light : Brightness.dark,
      ),
    );
  }

  // Koyu tema
  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: ColorConstants.primaryRed,
    scaffoldBackgroundColor: ColorConstants.backgroundBlack,
    colorScheme: const ColorScheme.dark(
      primary: ColorConstants.primaryRed,
      secondary: ColorConstants.secondaryBlue,
      background: ColorConstants.backgroundBlack,
      surface: ColorConstants.surfaceBlack,
      error: ColorConstants.statusError,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: ColorConstants.backgroundBlack,
      elevation: 0,
      centerTitle: true,
      iconTheme: IconThemeData(color: ColorConstants.textWhite),
      titleTextStyle: TextStyle(
        color: ColorConstants.textWhite, 
        fontSize: 18, 
        fontWeight: FontWeight.w600
      ),
    ),
    cardTheme: const CardTheme(
      color: ColorConstants.cardBlack,
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    ),
    dividerTheme: const DividerThemeData(
      color: ColorConstants.dividerColor,
      thickness: 1,
      space: 1,
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(color: ColorConstants.textWhite, fontSize: 26, fontWeight: FontWeight.bold),
      displayMedium: TextStyle(color: ColorConstants.textWhite, fontSize: 22, fontWeight: FontWeight.bold),
      displaySmall: TextStyle(color: ColorConstants.textWhite, fontSize: 18, fontWeight: FontWeight.w600),
      headlineMedium: TextStyle(color: ColorConstants.textWhite, fontSize: 16, fontWeight: FontWeight.w600),
      titleLarge: TextStyle(color: ColorConstants.textWhite, fontSize: 16, fontWeight: FontWeight.w600),
      titleMedium: TextStyle(color: ColorConstants.textWhite, fontSize: 14, fontWeight: FontWeight.w600),
      titleSmall: TextStyle(color: ColorConstants.textGrey, fontSize: 14, fontWeight: FontWeight.normal),
      bodyLarge: TextStyle(color: ColorConstants.textWhite, fontSize: 16, fontWeight: FontWeight.normal),
      bodyMedium: TextStyle(color: ColorConstants.textWhite, fontSize: 14, fontWeight: FontWeight.normal),
      bodySmall: TextStyle(color: ColorConstants.textGrey, fontSize: 12, fontWeight: FontWeight.normal),
    ),
    iconTheme: const IconThemeData(
      color: ColorConstants.iconColor,
      size: 24,
    ),
    buttonTheme: ButtonThemeData(
      buttonColor: ColorConstants.primaryRed,
      textTheme: ButtonTextTheme.primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: MaterialStateProperty.resolveWith<Color>(
        (Set<MaterialState> states) {
          if (states.contains(MaterialState.selected)) {
            return ColorConstants.primaryRed;
          }
          return ColorConstants.textGrey;
        },
      ),
      trackColor: MaterialStateProperty.resolveWith<Color>(
        (Set<MaterialState> states) {
          if (states.contains(MaterialState.selected)) {
            return ColorConstants.primaryRed.withOpacity(0.5);
          }
          return Colors.grey.withOpacity(0.5);
        },
      ),
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: MaterialStateProperty.resolveWith<Color>(
        (Set<MaterialState> states) {
          if (states.contains(MaterialState.selected)) {
            return ColorConstants.primaryRed;
          }
          return Colors.transparent;
        },
      ),
      checkColor: MaterialStateProperty.all(Colors.white),
      side: const BorderSide(color: ColorConstants.textGrey),
    ),
    radioTheme: RadioThemeData(
      fillColor: MaterialStateProperty.resolveWith<Color>(
        (Set<MaterialState> states) {
          if (states.contains(MaterialState.selected)) {
            return ColorConstants.primaryRed;
          }
          return ColorConstants.textGrey;
        },
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: ColorConstants.surfaceBlack,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
      hintStyle: TextStyle(color: ColorConstants.textGrey.withOpacity(0.7)),
      labelStyle: const TextStyle(color: ColorConstants.textGrey),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: ColorConstants.primaryRed, width: 2),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: ColorConstants.statusError, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: ColorConstants.statusError, width: 2),
      ),
      errorStyle: const TextStyle(color: ColorConstants.statusError),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: ColorConstants.surfaceBlack,
      selectedItemColor: ColorConstants.primaryRed,
      unselectedItemColor: ColorConstants.textGrey,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: ColorConstants.primaryRed,
      foregroundColor: Colors.white,
    ),
    dialogTheme: DialogTheme(
      backgroundColor: ColorConstants.surfaceBlack,
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
    snackBarTheme: const SnackBarThemeData(
      backgroundColor: ColorConstants.surfaceBlack,
      contentTextStyle: TextStyle(color: ColorConstants.textWhite),
      actionTextColor: ColorConstants.primaryRed,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
    ),
    tabBarTheme: const TabBarTheme(
      labelColor: ColorConstants.primaryRed,
      unselectedLabelColor: ColorConstants.textGrey,
      indicatorSize: TabBarIndicatorSize.tab,
      indicator: UnderlineTabIndicator(
        borderSide: BorderSide(
          color: ColorConstants.primaryRed,
          width: 2.0,
        ),
      ),
    ),
    chipTheme: const ChipThemeData(
      backgroundColor: ColorConstants.cardBlack,
      selectedColor: ColorConstants.primaryRed,
      disabledColor: ColorConstants.surfaceBlack,
      labelStyle: TextStyle(color: ColorConstants.textWhite),
      secondaryLabelStyle: TextStyle(color: Colors.white),
      brightness: Brightness.dark,
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: ColorConstants.primaryRed,
    ),
  );

  // Aydınlık tema (ileride kullanılacak)
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: ColorConstants.primaryRed,
    scaffoldBackgroundColor: ColorConstants.backgroundWhite,
    colorScheme: const ColorScheme.light(
      primary: ColorConstants.primaryRed,
      secondary: ColorConstants.secondaryBlue,
      background: ColorConstants.backgroundWhite,
      surface: ColorConstants.surfaceWhite,
      error: ColorConstants.statusError,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: ColorConstants.primaryRed,
      elevation: 0,
      centerTitle: true,
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(
        color: Colors.white, 
        fontSize: 18, 
        fontWeight: FontWeight.w600
      ),
    ),
    cardTheme: const CardTheme(
      color: ColorConstants.cardWhite,
      elevation: 2,
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    ),
    dividerTheme: const DividerThemeData(
      color: Color(0xFFE0E0E0),
      thickness: 1,
      space: 1,
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(color: ColorConstants.textBlack, fontSize: 26, fontWeight: FontWeight.bold),
      displayMedium: TextStyle(color: ColorConstants.textBlack, fontSize: 22, fontWeight: FontWeight.bold),
      displaySmall: TextStyle(color: ColorConstants.textBlack, fontSize: 18, fontWeight: FontWeight.w600),
      headlineMedium: TextStyle(color: ColorConstants.textBlack, fontSize: 16, fontWeight: FontWeight.w600),
      titleLarge: TextStyle(color: ColorConstants.textBlack, fontSize: 16, fontWeight: FontWeight.w600),
      titleMedium: TextStyle(color: ColorConstants.textBlack, fontSize: 14, fontWeight: FontWeight.w600),
      titleSmall: TextStyle(color: Colors.grey.shade600, fontSize: 14, fontWeight: FontWeight.normal),
      bodyLarge: TextStyle(color: ColorConstants.textBlack, fontSize: 16, fontWeight: FontWeight.normal),
      bodyMedium: TextStyle(color: ColorConstants.textBlack, fontSize: 14, fontWeight: FontWeight.normal),
      bodySmall: TextStyle(color: Colors.grey.shade600, fontSize: 12, fontWeight: FontWeight.normal),
    ),
    iconTheme: const IconThemeData(
      color: Colors.grey,
      size: 24,
    ),
    buttonTheme: ButtonThemeData(
      buttonColor: ColorConstants.primaryRed,
      textTheme: ButtonTextTheme.primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: MaterialStateProperty.resolveWith<Color>(
        (Set<MaterialState> states) {
          if (states.contains(MaterialState.selected)) {
            return ColorConstants.primaryRed;
          }
          return Colors.grey;
        },
      ),
      trackColor: MaterialStateProperty.resolveWith<Color>(
        (Set<MaterialState> states) {
          if (states.contains(MaterialState.selected)) {
            return ColorConstants.primaryRed.withOpacity(0.5);
          }
          return Colors.grey.withOpacity(0.5);
        },
      ),
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: MaterialStateProperty.resolveWith<Color>(
        (Set<MaterialState> states) {
          if (states.contains(MaterialState.selected)) {
            return ColorConstants.primaryRed;
          }
          return Colors.transparent;
        },
      ),
      checkColor: MaterialStateProperty.all(Colors.white),
      side: BorderSide(color: Colors.grey.shade400),
    ),
    radioTheme: RadioThemeData(
      fillColor: MaterialStateProperty.resolveWith<Color>(
        (Set<MaterialState> states) {
          if (states.contains(MaterialState.selected)) {
            return ColorConstants.primaryRed;
          }
          return Colors.grey;
        },
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.grey.shade100,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
      hintStyle: TextStyle(color: Colors.grey.shade500),
      labelStyle: TextStyle(color: Colors.grey.shade700),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: ColorConstants.primaryRed, width: 2),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: ColorConstants.statusError, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: ColorConstants.statusError, width: 2),
      ),
      errorStyle: const TextStyle(color: ColorConstants.statusError),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: ColorConstants.primaryRed,
      unselectedItemColor: Colors.grey.shade600,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: ColorConstants.primaryRed,
      foregroundColor: Colors.white,
    ),
    dialogTheme: DialogTheme(
      backgroundColor: Colors.white,
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: Colors.grey.shade800,
      contentTextStyle: const TextStyle(color: Colors.white),
      actionTextColor: ColorConstants.primaryRed,
      behavior: SnackBarBehavior.floating,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
    ),
    tabBarTheme: TabBarTheme(
      labelColor: ColorConstants.primaryRed,
      unselectedLabelColor: Colors.grey.shade600,
      indicatorSize: TabBarIndicatorSize.tab,
      indicator: const UnderlineTabIndicator(
        borderSide: BorderSide(
          color: ColorConstants.primaryRed,
          width: 2.0,
        ),
      ),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: Colors.grey.shade200,
      selectedColor: ColorConstants.primaryRed,
      disabledColor: Colors.grey.shade300,
      labelStyle: const TextStyle(color: ColorConstants.textBlack),
      secondaryLabelStyle: const TextStyle(color: Colors.white),
      brightness: Brightness.light,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: ColorConstants.primaryRed,
    ),
  );
}