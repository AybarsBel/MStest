import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../constants/app_constants.dart';
import 'permission_util.dart';

class FileUtil {
  // QR kodu PNG olarak kaydet
  static Future<String?> saveQrCodeAsPng(String memberId, List<int> pngBytes) async {
    if (!await PermissionUtil.requestStoragePermission()) {
      return null;
    }

    try {
      final appDocDir = await getApplicationDocumentsDirectory();
      final qrDir = Directory('${appDocDir.path}/${AppConstants.qrFolder}');
      
      if (!await qrDir.exists()) {
        await qrDir.create(recursive: true);
      }
      
      final fileName = 'qr_${memberId}_${DateTime.now().millisecondsSinceEpoch}.png';
      final filePath = '${qrDir.path}/$fileName';
      
      final file = File(filePath);
      await file.writeAsBytes(pngBytes);
      
      return filePath;
    } catch (e) {
      print('QR PNG kaydetme hatası: $e');
      return null;
    }
  }

  // QR kodu PDF olarak kaydet
  static Future<String?> saveQrCodeAsPdf(String memberId, List<int> pngBytes, String memberName) async {
    if (!await PermissionUtil.requestStoragePermission()) {
      return null;
    }

    try {
      final appDocDir = await getApplicationDocumentsDirectory();
      final qrDir = Directory('${appDocDir.path}/${AppConstants.qrFolder}');
      
      if (!await qrDir.exists()) {
        await qrDir.create(recursive: true);
      }
      
      final fileName = 'qr_${memberId}_${DateTime.now().millisecondsSinceEpoch}.pdf';
      final filePath = '${qrDir.path}/$fileName';
      
      final pdf = pw.Document();
      
      final image = pw.MemoryImage(pngBytes);
      
      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return pw.Center(
              child: pw.Column(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                children: [
                  pw.Text('MS FITNESS', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
                  pw.SizedBox(height: 10),
                  pw.Text(memberName, style: pw.TextStyle(fontSize: 18)),
                  pw.SizedBox(height: 20),
                  pw.Container(
                    width: 200,
                    height: 200,
                    child: pw.Image(image),
                  ),
                  pw.SizedBox(height: 20),
                  pw.Text('Üye ID: $memberId', style: pw.TextStyle(fontSize: 14)),
                ],
              ),
            );
          },
        ),
      );
      
      final file = File(filePath);
      await file.writeAsBytes(await pdf.save());
      
      return filePath;
    } catch (e) {
      print('QR PDF kaydetme hatası: $e');
      return null;
    }
  }

  // Gelir raporunu PDF olarak kaydet
  static Future<String?> saveIncomeReportAsPdf(
    Map<String, double> incomeData,
    double totalIncome,
    double potentialIncome,
    DateTime startDate,
    DateTime endDate,
  ) async {
    if (!await PermissionUtil.requestStoragePermission()) {
      return null;
    }

    try {
      final appDocDir = await getApplicationDocumentsDirectory();
      final reportsDir = Directory('${appDocDir.path}/${AppConstants.reportsFolder}');
      
      if (!await reportsDir.exists()) {
        await reportsDir.create(recursive: true);
      }
      
      final fileName = 'gelir_raporu_${DateTime.now().millisecondsSinceEpoch}.pdf';
      final filePath = '${reportsDir.path}/$fileName';
      
      final pdf = pw.Document();
      
      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return pw.Padding(
              padding: const pw.EdgeInsets.all(20),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Center(
                    child: pw.Text(
                      'MS FITNESS GELİR RAPORU',
                      style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold),
                    ),
                  ),
                  pw.SizedBox(height: 20),
                  pw.Text(
                    'Rapor Dönemi: ${startDate.day}.${startDate.month}.${startDate.year} - ${endDate.day}.${endDate.month}.${endDate.year}',
                    style: pw.TextStyle(fontSize: 14),
                  ),
                  pw.SizedBox(height: 20),
                  pw.Table(
                    border: pw.TableBorder.all(),
                    children: [
                      pw.TableRow(
                        decoration: pw.BoxDecoration(color: PdfColors.grey300),
                        children: [
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(8),
                            child: pw.Text('Ay', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(8),
                            child: pw.Text('Gelir (₺)', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                          ),
                        ],
                      ),
                      ...incomeData.entries.map((entry) => pw.TableRow(
                        children: [
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(8),
                            child: pw.Text(entry.key),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(8),
                            child: pw.Text('${entry.value.toStringAsFixed(2)} ₺'),
                          ),
                        ],
                      )).toList(),
                    ],
                  ),
                  pw.SizedBox(height: 20),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text('Toplam Gelir:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      pw.Text('${totalIncome.toStringAsFixed(2)} ₺', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    ],
                  ),
                  pw.SizedBox(height: 10),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text('Potansiyel Gelir:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      pw.Text('${potentialIncome.toStringAsFixed(2)} ₺', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    ],
                  ),
                  pw.SizedBox(height: 30),
                  pw.Text('* Potansiyel gelir, tüm üyelerin ödeme yapması halinde elde edilecek toplam geliri gösterir.'),
                  pw.SizedBox(height: 40),
                  pw.Footer(
                    margin: const pw.EdgeInsets.only(top: 20),
                    title: pw.Text(
                      'Rapor Tarihi: ${DateTime.now().day}.${DateTime.now().month}.${DateTime.now().year}',
                      style: const pw.TextStyle(fontSize: 10),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      );
      
      final file = File(filePath);
      await file.writeAsBytes(await pdf.save());
      
      return filePath;
    } catch (e) {
      print('Gelir raporu PDF kaydetme hatası: $e');
      return null;
    }
  }

  // Verileri JSON olarak yedekle
  static Future<String?> backupDataAsJson(String jsonData) async {
    if (!await PermissionUtil.requestStoragePermission()) {
      return null;
    }

    try {
      final appDocDir = await getApplicationDocumentsDirectory();
      final backupDir = Directory('${appDocDir.path}/${AppConstants.backupFolder}');
      
      if (!await backupDir.exists()) {
        await backupDir.create(recursive: true);
      }
      
      final fileName = 'ms_fitness_backup_${DateTime.now().millisecondsSinceEpoch}.json';
      final filePath = '${backupDir.path}/$fileName';
      
      final file = File(filePath);
      await file.writeAsString(jsonData);
      
      return filePath;
    } catch (e) {
      print('Veri yedekleme hatası: $e');
      return null;
    }
  }

  // Yedekten JSON verilerini oku
  static Future<String?> readBackupJson(String filePath) async {
    try {
      final file = File(filePath);
      if (await file.exists()) {
        return await file.readAsString();
      }
      return null;
    } catch (e) {
      print('Yedek okuma hatası: $e');
      return null;
    }
  }

  // Profil fotoğrafını kaydet
  static Future<String?> saveProfileImage(String memberId, List<int> imageBytes) async {
    if (!await PermissionUtil.requestStoragePermission()) {
      return null;
    }

    try {
      final appDocDir = await getApplicationDocumentsDirectory();
      final profileImagesDir = Directory('${appDocDir.path}/${AppConstants.profileImagesFolder}');
      
      if (!await profileImagesDir.exists()) {
        await profileImagesDir.create(recursive: true);
      }
      
      final fileName = 'profile_${memberId}.jpg';
      final filePath = '${profileImagesDir.path}/$fileName';
      
      final file = File(filePath);
      await file.writeAsBytes(imageBytes);
      
      return filePath;
    } catch (e) {
      print('Profil fotoğrafı kaydetme hatası: $e');
      return null;
    }
  }

  // Profil fotoğrafını sil
  static Future<bool> deleteProfileImage(String imagePath) async {
    try {
      final file = File(imagePath);
      if (await file.exists()) {
        await file.delete();
        return true;
      }
      return false;
    } catch (e) {
      print('Profil fotoğrafı silme hatası: $e');
      return false;
    }
  }
}
