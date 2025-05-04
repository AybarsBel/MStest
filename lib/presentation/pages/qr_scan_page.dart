import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../core/constants/color_constants.dart';
import '../../core/constants/text_constants.dart';
import '../../logic/cubits/qr_code/qr_code_cubit.dart';
import '../pages/member_detail_page.dart';
import '../widgets/common/custom_app_bar.dart';

class QrScanPage extends StatefulWidget {
  const QrScanPage({Key? key}) : super(key: key);

  @override
  State<QrScanPage> createState() => _QrScanPageState();
}

class _QrScanPageState extends State<QrScanPage> {
  final MobileScannerController _scannerController = MobileScannerController();
  bool _isScanning = true;

  @override
  void dispose() {
    _scannerController.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) {
    final List<Barcode> barcodes = capture.barcodes;
    
    if (barcodes.isNotEmpty && _isScanning) {
      setState(() {
        _isScanning = false;
      });
      
      final qrData = barcodes.first.rawValue;
      if (qrData != null) {
        // QR kodu işle
        context.read<QrCodeCubit>().scanQrCode(qrData);
      } else {
        setState(() {
          _isScanning = true;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('QR kod okunamadı, tekrar deneyiniz')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: TextConstants.qrCodeScan,
      ),
      body: BlocListener<QrCodeCubit, QrCodeState>(
        listener: (context, state) {
          if (state is QrCodeError) {
            setState(() {
              _isScanning = true;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          } else if (state is MemberScanned) {
            // Üye detay sayfasına git
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => MemberDetailPage(memberId: state.member.id),
              ),
            );
          }
        },
        child: Stack(
          children: [
            // QR tarayıcı
            MobileScanner(
              controller: _scannerController,
              onDetect: _onDetect,
            ),
            // Kılavuz çerçeve
            Center(
              child: Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: ColorConstants.primaryRed,
                    width: 3,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            // Alt bilgi
            Positioned(
              bottom: 30,
              left: 0,
              right: 0,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 32),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: ColorConstants.backgroundBlack.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    const Text(
                      'QR Kodu Tarayıcıya Yaklaştırın',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: ColorConstants.textWhite,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          onPressed: () => _scannerController.toggleTorch(),
                          icon: const Icon(
                            Icons.flash_on,
                            color: ColorConstants.primaryRed,
                          ),
                        ),
                        IconButton(
                          onPressed: () => _scannerController.switchCamera(),
                          icon: const Icon(
                            Icons.switch_camera,
                            color: ColorConstants.primaryRed,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
