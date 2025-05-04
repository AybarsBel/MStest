import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/constants/color_constants.dart';
import '../../core/constants/text_constants.dart';
import '../../logic/blocs/member/member_bloc.dart';
import '../pages/member_detail_page.dart';
import '../widgets/common/custom_app_bar.dart';
import '../widgets/member/member_list_item.dart';

class RenewalMembersPage extends StatefulWidget {
  const RenewalMembersPage({Key? key}) : super(key: key);

  @override
  State<RenewalMembersPage> createState() => _RenewalMembersPageState();
}

class _RenewalMembersPageState extends State<RenewalMembersPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    
    // Yenilenecek üyeleri yükle
    context.read<MemberBloc>().add(LoadRenewalMembers());
    
    // Tab değişikliğini dinle
    _tabController.addListener(_onTabChanged);
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    super.dispose();
  }

  void _onTabChanged() {
    if (_tabController.index == 0) {
      context.read<MemberBloc>().add(LoadRenewalMembers());
    } else {
      context.read<MemberBloc>().add(LoadOverdueMembers());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: TextConstants.renewalMembers,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: ColorConstants.primaryRed,
          tabs: const [
            Tab(text: 'Süresi Yakında Dolacak'),
            Tab(text: 'Borçlu Üyeler'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Süresi yakında dolacak üyeler
          BlocBuilder<MemberBloc, MemberState>(
            builder: (context, state) {
              if (state is MemberLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is RenewalMembersLoaded) {
                final members = state.members;
                
                if (members.isEmpty) {
                  return _buildEmptyState('Yakında süresi dolacak üye bulunamadı');
                }
                
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: members.length,
                  itemBuilder: (context, index) {
                    final member = members[index];
                    return MemberListItem(
                      member: member,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MemberDetailPage(memberId: member.id),
                          ),
                        );
                      },
                    );
                  },
                );
              } else {
                return _buildEmptyState('Veriler yüklenirken bir hata oluştu');
              }
            },
          ),
          // Borçlu üyeler
          BlocBuilder<MemberBloc, MemberState>(
            builder: (context, state) {
              if (state is MemberLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is OverdueMembersLoaded) {
                final members = state.members;
                
                if (members.isEmpty) {
                  return _buildEmptyState('Borçlu üye bulunamadı');
                }
                
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: members.length,
                  itemBuilder: (context, index) {
                    final member = members[index];
                    return MemberListItem(
                      member: member,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MemberDetailPage(memberId: member.id),
                          ),
                        );
                      },
                    );
                  },
                );
              } else {
                return _buildEmptyState('Veriler yüklenirken bir hata oluştu');
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.notifications_none,
            size: 64,
            color: ColorConstants.textGrey,
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: const TextStyle(
              color: ColorConstants.textGrey,
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
