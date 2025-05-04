import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/text_constants.dart';
import '../../../data/models/member.dart';
import '../../../data/models/payment.dart';
import '../../../logic/blocs/member/member_bloc.dart';
import '../../../logic/blocs/payment/payment_bloc.dart';
import '../../widgets/common/dashboard_card.dart';
import 'widgets/members_summary_card.dart';
import 'widgets/recent_payments_card.dart';
import 'widgets/renewals_card.dart';
import 'widgets/monthly_income_chart.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Verileri yükle
    context.read<MemberBloc>().add(LoadAllMembers());
    context.read<MemberBloc>().add(LoadRenewalMembers());
    context.read<PaymentBloc>().add(LoadAllPayments());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(TextConstants.homeTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code_scanner),
            onPressed: () => Navigator.pushNamed(context, AppConstants.routeQrScanner),
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.pushNamed(context, AppConstants.routeSettings),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<MemberBloc>().add(LoadAllMembers());
          context.read<MemberBloc>().add(LoadRenewalMembers());
          context.read<PaymentBloc>().add(LoadAllPayments());
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDashboardSummary(context),
              const SizedBox(height: 24),
              _buildMembersSummary(context),
              const SizedBox(height: 24),
              _buildRenewalsList(context),
              const SizedBox(height: 24),
              _buildRecentPayments(context),
              const SizedBox(height: 24),
              _buildMonthlyIncomeChart(context),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, AppConstants.routeAddMember),
        child: const Icon(Icons.person_add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        items: const [
          BottomNavigationBar.item(
            icon: Icon(Icons.home),
            label: TextConstants.homeTitle,
          ),
          BottomNavigationBar.item(
            icon: Icon(Icons.people),
            label: TextConstants.membersTitle,
          ),
          BottomNavigationBar.item(
            icon: Icon(Icons.payment),
            label: TextConstants.paymentsTitle,
          ),
          BottomNavigationBar.item(
            icon: Icon(Icons.bar_chart),
            label: TextConstants.reportsTitle,
          ),
        ],
        onTap: (index) {
          if (index == 0) {
            // Zaten ana sayfadayız
          } else if (index == 1) {
            Navigator.pushNamed(context, AppConstants.routeMembers);
          } else if (index == 2) {
            Navigator.pushNamed(context, AppConstants.routePayments, arguments: null);
          } else if (index == 3) {
            Navigator.pushNamed(context, AppConstants.routeReports);
          }
        },
      ),
    );
  }

  Widget _buildDashboardSummary(BuildContext context) {
    return BlocBuilder<MemberBloc, MemberState>(
      builder: (context, memberState) {
        int totalMembers = 0;
        int activeMembers = 0;
        int pendingRenewals = 0;

        if (memberState is MembersLoaded) {
          totalMembers = memberState.members.length;
          activeMembers = memberState.members.where((m) => m.isActive).length;
        }

        return BlocBuilder<PaymentBloc, PaymentState>(
          builder: (context, paymentState) {
            double monthlyIncome = 0;

            if (paymentState is PaymentsLoaded) {
              // Son 30 günlük ödemeleri hesapla
              final now = DateTime.now();
              final thirtyDaysAgo = now.subtract(const Duration(days: 30));
              
              monthlyIncome = paymentState.payments
                  .where((p) => p.paymentDate.isAfter(thirtyDaysAgo))
                  .fold(0, (sum, payment) => sum + payment.amount);
            }

            if (memberState is MembersLoaded && memberState.members.isNotEmpty) {
              pendingRenewals = memberState.members
                  .where((m) => m.membershipEndingSoon)
                  .length;
            }

            return Row(
              children: [
                Expanded(
                  child: DashboardCard(
                    title: TextConstants.totalMembers,
                    value: totalMembers.toString(),
                    icon: Icons.people_alt,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: DashboardCard(
                    title: TextConstants.activeMembers,
                    value: activeMembers.toString(),
                    icon: Icons.person,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: DashboardCard(
                    title: TextConstants.pendingRenewals,
                    value: pendingRenewals.toString(),
                    icon: Icons.schedule,
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: DashboardCard(
                    title: TextConstants.monthlyIncome,
                    value: '₺${monthlyIncome.toStringAsFixed(2)}',
                    icon: Icons.monetization_on,
                    color: Colors.green,
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildMembersSummary(BuildContext context) {
    return BlocBuilder<MemberBloc, MemberState>(
      builder: (context, state) {
        List<Member> members = [];

        if (state is MembersLoaded) {
          members = state.members;
        }

        return MembersSummaryCard(
          members: members,
          onTap: () => Navigator.pushNamed(context, AppConstants.routeMembers),
        );
      },
    );
  }

  Widget _buildRenewalsList(BuildContext context) {
    return BlocBuilder<MemberBloc, MemberState>(
      builder: (context, state) {
        List<Member> renewalMembers = [];

        if (state is MembersLoaded) {
          renewalMembers = state.members
              .where((m) => m.membershipEndingSoon)
              .toList();
        }

        return RenewalsCard(
          renewalMembers: renewalMembers,
          onTap: (memberId) => Navigator.pushNamed(
            context,
            AppConstants.routeMemberDetail,
            arguments: memberId,
          ),
        );
      },
    );
  }

  Widget _buildRecentPayments(BuildContext context) {
    return BlocBuilder<PaymentBloc, PaymentState>(
      builder: (context, state) {
        List<Payment> recentPayments = [];

        if (state is PaymentsLoaded) {
          recentPayments = state.payments
            ..sort((a, b) => b.paymentDate.compareTo(a.paymentDate));

          if (recentPayments.length > 5) {
            recentPayments = recentPayments.sublist(0, 5);
          }
        }

        return RecentPaymentsCard(
          payments: recentPayments,
          onTap: () => Navigator.pushNamed(
            context,
            AppConstants.routePayments,
            arguments: null,
          ),
        );
      },
    );
  }

  Widget _buildMonthlyIncomeChart(BuildContext context) {
    return BlocBuilder<PaymentBloc, PaymentState>(
      builder: (context, state) {
        List<Payment> payments = [];

        if (state is PaymentsLoaded) {
          payments = state.payments;
        }

        return MonthlyIncomeChart(
          payments: payments,
          onTap: () => Navigator.pushNamed(context, AppConstants.routeReports),
        );
      },
    );
  }
}