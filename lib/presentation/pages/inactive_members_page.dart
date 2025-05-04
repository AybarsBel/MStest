import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/constants/color_constants.dart';
import '../../core/constants/text_constants.dart';
import '../../logic/blocs/member/member_bloc.dart';
import '../widgets/common/custom_app_bar.dart';
import '../widgets/member/member_list_item.dart';
import 'member_detail_page.dart';

class InactiveMembersPage extends StatefulWidget {
  const InactiveMembersPage({Key? key}) : super(key: key);

  @override
  State<InactiveMembersPage> createState() => _InactiveMembersPageState();
}

class _InactiveMembersPageState extends State<InactiveMembersPage> {
  @override
  void initState() {
    super.initState();
    // Pasif üyeleri yükle
    context.read<MemberBloc>().add(LoadInactiveMembers());
  }

  void _activateMember(String memberId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(TextConstants.confirmReactivate),
        content: const Text(
          'Bu üye aktif listeye taşınacak. Devam etmek istiyor musunuz?'
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(TextConstants.no),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<MemberBloc>().add(ActivateMember(memberId));
            },
            child: Text(
              TextConstants.yes,
              style: const TextStyle(color: ColorConstants.primaryRed),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: TextConstants.inactiveMembers,
      ),
      body: BlocConsumer<MemberBloc, MemberState>(
        listener: (context, state) {
          if (state is MemberError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          } else if (state is MemberActionSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
            // Listeyi yenile
            context.read<MemberBloc>().add(LoadInactiveMembers());
          }
        },
        builder: (context, state) {
          if (state is MemberLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is InactiveMembersLoaded) {
            final members = state.members;
            
            if (members.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.person_off,
                      size: 64,
                      color: ColorConstants.textGrey,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Pasif üye bulunamadı',
                      style: TextStyle(
                        color: ColorConstants.textGrey,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              );
            }
            
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: members.length,
              itemBuilder: (context, index) {
                final member = members[index];
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MemberDetailPage(memberId: member.id),
                      ),
                    );
                  },
                  child: Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          MemberListItem(
                            member: member,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MemberDetailPage(memberId: member.id),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 12),
                          const Divider(),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton.icon(
                                onPressed: () => _activateMember(member.id),
                                icon: const Icon(
                                  Icons.person_add,
                                  color: ColorConstants.primaryRed,
                                ),
                                label: Text(
                                  TextConstants.makeActive,
                                  style: const TextStyle(
                                    color: ColorConstants.primaryRed,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(
              child: Text('Pasif üyeler yüklenemedi'),
            );
          }
        },
      ),
    );
  }
}
