import 'package:permission_handler/permission_handler.dart';

class PermissionUtil {
  // Kamera izni iste
  static Future<bool> requestCameraPermission() async {
    var status = await Permission.camera.status;
    
    if (status.isDenied) {
      status = await Permission.camera.request();
    }
    
    return status.isGranted;
  }

  // Depolama izni iste
  static Future<bool> requestStoragePermission() async {
    // Android 11 ve üstü için Storage Access Framework
    if (await Permission.manageExternalStorage.isSupported) {
      var status = await Permission.manageExternalStorage.status;
      
      if (status.isDenied) {
        status = await Permission.manageExternalStorage.request();
      }
      
      if (status.isGranted) {
        return true;
      }
    }
    
    // Eski Android sürümleri için
    var status = await Permission.storage.status;
    
    if (status.isDenied) {
      status = await Permission.storage.request();
    }
    
    return status.isGranted;
  }

  // Tüm gerekli izinleri iste
  static Future<Map<Permission, PermissionStatus>> requestAllPermissions() async {
    return await [
      Permission.camera,
      Permission.storage,
    ].request();
  }

  // İzin durumlarını kontrol et
  static Future<Map<String, bool>> checkPermissionStatus() async {
    return {
      'camera': await Permission.camera.isGranted,
      'storage': await Permission.storage.isGranted || await Permission.manageExternalStorage.isGranted,
    };
  }
}
