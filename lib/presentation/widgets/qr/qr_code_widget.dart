import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../core/constants/color_constants.dart';
import '../../../data/models/member.dart';
import '../../widgets/common/custom_button.dart';

class QrCodeWidget extends StatelessWidget {
  final String qrData;
  final Member member;
  final GlobalKey qrKey;
  final Function() onExportPng;
  final Function() onExportPdf;

  const QrCodeWidget({
    Key? key,
    required this.qrData,
    required this.member,
    required this.qrKey,
    required this.onExportPng,
    required this.onExportPdf,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'MS FITNESS',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: ColorConstants.primaryRed,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              member.fullName,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: ColorConstants.textWhite,
              ),
            ),
            const SizedBox(height: 24),
            RepaintBoundary(
              key: qrKey,
              child: QrImageView(
                data: qrData,
                version: QrVersions.auto,
                size: 200,
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.all(16),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Üye ID: ${member.id}',
              style: const TextStyle(
                color: ColorConstants.textGrey,
              ),
            ),
            const SizedBox(height: 32),
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    text: 'PNG Olarak Kaydet',
                    icon: Icons.download,
                    onPressed: onExportPng,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: CustomButton(
                    text: 'PDF Olarak Kaydet',
                    icon: Icons.picture_as_pdf,
                    onPressed: onExportPdf,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
