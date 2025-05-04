import 'package:flutter/material.dart';
import '../../../core/constants/color_constants.dart';
import '../../../core/constants/text_constants.dart';
import '../../pages/home_page.dart';
import '../../pages/add_member_page.dart';
import '../../pages/qr_scan_page.dart';
import '../../pages/income_report_page.dart';
import '../../pages/settings_page.dart';
import '../../pages/renewal_members_page.dart';
import '../../pages/inactive_members_page.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: ColorConstants.backgroundBlack,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: ColorConstants.primaryDarkRed,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Icon(
                  Icons.fitness_center,
                  color: Colors.white,
                  size: 48,
                ),
                const SizedBox(height: 16),
                Text(
                  TextConstants.appTitle,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Üye Yönetim Sistemi',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.white,
                      ),
                ),
              ],
            ),
          ),
          _buildDrawerItem(
            context,
            icon: Icons.home,
            title: 'Ana Sayfa',
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const HomePage()),
              );
            },
          ),
          _buildDrawerItem(
            context,
            icon: Icons.person_add,
            title: TextConstants.addMember,
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddMemberPage()),
              );
            },
          ),
          _buildDrawerItem(
            context,
            icon: Icons.qr_code_scanner,
            title: TextConstants.qrCodeScan,
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const QrScanPage()),
              );
            },
          ),
          _buildDrawerItem(
            context,
            icon: Icons.timer,
            title: TextConstants.renewalMembers,
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const RenewalMembersPage()),
              );
            },
          ),
          _buildDrawerItem(
            context,
            icon: Icons.person_off,
            title: TextConstants.inactiveMembers,
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const InactiveMembersPage()),
              );
            },
          ),
          _buildDrawerItem(
            context,
            icon: Icons.bar_chart,
            title: TextConstants.incomeReport,
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const IncomeReportPage()),
              );
            },
          ),
          const Divider(color: ColorConstants.dividerColor),
          _buildDrawerItem(
            context,
            icon: Icons.settings,
            title: TextConstants.settings,
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsPage()),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: ColorConstants.primaryRed,
      ),
      title: Text(
        title,
        style: const TextStyle(
          color: ColorConstants.textWhite,
        ),
      ),
      onTap: onTap,
      tileColor: ColorConstants.backgroundBlack,
      hoverColor: ColorConstants.cardBlack,
    );
  }
}
