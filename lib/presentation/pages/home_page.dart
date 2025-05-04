import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/constants/text_constants.dart';
import '../../core/constants/color_constants.dart';
import '../../logic/blocs/member/member_bloc.dart';
import '../widgets/common/app_drawer.dart';
import '../widgets/common/custom_app_bar.dart';
import '../widgets/member/member_list_item.dart';
import 'add_member_page.dart';
import 'qr_scan_page.dart';
import 'member_detail_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  
  @override
  void initState() {
    super.initState();
    // Üyeleri yükle
    context.read<MemberBloc>().add(LoadMembers());
    
    // Arama alanı değişikliklerini dinle
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    if (_searchController.text.isEmpty) {
      context.read<MemberBloc>().add(LoadMembers());
    } else {
      context.read<MemberBloc>().add(SearchMembers(_searchController.text));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: TextConstants.appTitle,
        showBackButton: false,
      ),
      drawer: const AppDrawer(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: TextConstants.search,
                prefixIcon: const Icon(Icons.search, color: ColorConstants.primaryRed),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: ColorConstants.primaryRed),
                        onPressed: () {
                          _searchController.clear();
                        },
                      )
                    : null,
              ),
            ),
          ),
          Expanded(
            child: BlocConsumer<MemberBloc, MemberState>(
              listener: (context, state) {
                if (state is MemberError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.message)),
                  );
                }
              },
              builder: (context, state) {
                if (state is MemberLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is MembersLoaded) {
                  final members = state.members;
                  
                  if (members.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.person_off,
                            size: 64,
                            color: ColorConstants.textGrey,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            TextConstants.noMembersFound,
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: ColorConstants.textGrey,
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  
                  return ListView.builder(
                    padding: const EdgeInsets.all(8.0),
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
                  return const Center(child: Text('Üyeler yüklenemedi'));
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // QR kod tarama butonu
          FloatingActionButton(
            heroTag: 'qrScan',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const QrScanPage()),
              );
            },
            backgroundColor: ColorConstants.backgroundBlack,
            child: const Icon(Icons.qr_code_scanner, color: ColorConstants.primaryRed),
          ),
          const SizedBox(width: 16),
          // Üye ekleme butonu
          FloatingActionButton(
            heroTag: 'addMember',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddMemberPage()),
              );
            },
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
