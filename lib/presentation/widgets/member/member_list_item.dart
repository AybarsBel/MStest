import 'package:flutter/material.dart';
import '../../../core/constants/color_constants.dart';
import '../../../core/constants/text_constants.dart';
import '../../../core/utils/date_util.dart';
import '../../../data/models/member.dart';
import 'dart:io';

class MemberListItem extends StatelessWidget {
  final Member member;
  final VoidCallback onTap;

  const MemberListItem({
    Key? key,
    required this.member,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Üyelik durumuna göre renk belirle
    Color statusColor;
    switch (member.status) {
      case 'Aktif':
        statusColor = ColorConstants.statusActive;
        break;
      case 'Borçlu':
        statusColor = ColorConstants.statusOverdue;
        break;
      default:
        statusColor = ColorConstants.statusInactive;
    }

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              // Profil fotoğrafı
              CircleAvatar(
                radius: 30,
                backgroundColor: ColorConstants.primaryRed,
                backgroundImage: member.profileImagePath != null && member.profileImagePath!.isNotEmpty
                    ? FileImage(File(member.profileImagePath!))
                    : null,
                child: member.profileImagePath == null || member.profileImagePath!.isEmpty
                    ? const Icon(
                        Icons.person,
                        size: 30,
                        color: Colors.white,
                      )
                    : null,
              ),
              const SizedBox(width: 16),
              // Üye bilgileri
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      member.fullName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: ColorConstants.textWhite,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      member.phoneNumber ?? '',
                      style: const TextStyle(
                        fontSize: 14,
                        color: ColorConstants.textGrey,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${TextConstants.registrationDate}: ${DateUtil.formatDate(member.registrationDate)}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: ColorConstants.textGrey,
                      ),
                    ),
                  ],
                ),
              ),
              // Üyelik durumu
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  member.status,
                  style: TextStyle(
                    color: statusColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
