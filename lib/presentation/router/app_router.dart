import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../screens/home/home_screen.dart';
import '../screens/member/member_list_screen.dart';
import '../screens/member/member_detail_screen.dart';
import '../screens/member/member_add_screen.dart';
import '../screens/member/member_edit_screen.dart';
import '../screens/payment/payment_list_screen.dart';
import '../screens/payment/payment_add_screen.dart';
import '../screens/reports/reports_screen.dart';
import '../screens/qr_code/qr_scanner_screen.dart';
import '../screens/qr_code/qr_generator_screen.dart';
import '../screens/settings/settings_screen.dart';

/// Uygulama yönlendirici sınıfı
class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppConstants.routeHome:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      
      case AppConstants.routeMembers:
        return MaterialPageRoute(builder: (_) => const MemberListScreen());
      
      case AppConstants.routeMemberDetail:
        final memberId = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => MemberDetailScreen(memberId: memberId),
        );
      
      case AppConstants.routeAddMember:
        return MaterialPageRoute(builder: (_) => const MemberAddScreen());
      
      case AppConstants.routeEditMember:
        final memberId = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => MemberEditScreen(memberId: memberId),
        );
      
      case AppConstants.routePayments:
        final memberId = settings.arguments as String?;
        return MaterialPageRoute(
          builder: (_) => PaymentListScreen(memberId: memberId),
        );
      
      case AppConstants.routeAddPayment:
        final memberId = settings.arguments as String?;
        return MaterialPageRoute(
          builder: (_) => PaymentAddScreen(memberId: memberId),
        );
      
      case AppConstants.routeReports:
        return MaterialPageRoute(builder: (_) => const ReportsScreen());
      
      case AppConstants.routeQrScanner:
        return MaterialPageRoute(builder: (_) => const QrScannerScreen());
      
      case AppConstants.routeQrGenerator:
        final memberId = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => QrGeneratorScreen(memberId: memberId),
        );
      
      case AppConstants.routeSettings:
        return MaterialPageRoute(builder: (_) => const SettingsScreen());
      
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('Sayfa bulunamadı: ${settings.name}'),
            ),
          ),
        );
    }
  }
}