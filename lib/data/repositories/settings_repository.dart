import '../datasources/local/database_helper.dart';
import '../../core/constants/app_constants.dart';

/// Ayarlar ile ilgili veritabanı işlemlerini yöneten repository sınıfı
class SettingsRepository {
  final DatabaseHelper _dbHelper;

  SettingsRepository(this._dbHelper);

  /// Başlangıç ayarlarını yükle
  Future<void> initSettings() async {
    final darkMode = await getSetting(AppConstants.settingDarkMode);
    final defaultMembershipDuration = await getSetting(AppConstants.settingDefaultMembershipDuration);
    final defaultPaymentType = await getSetting(AppConstants.settingDefaultPaymentType);
    final autoBackup = await getSetting(AppConstants.settingAutoBackup);
    final notificationsEnabled = await getSetting(AppConstants.settingNotificationsEnabled);
    final renewalReminderDays = await getSetting(AppConstants.settingRenewalReminderDays);

    // Eğer ayarlar yüklenmemişse varsayılan değerleri atayalım
    if (darkMode == null) {
      await setSetting(AppConstants.settingDarkMode, AppConstants.defaultDarkMode.toString());
    }

    if (defaultMembershipDuration == null) {
      await setSetting(
        AppConstants.settingDefaultMembershipDuration,
        AppConstants.defaultMembershipDurationDays.toString(),
      );
    }

    if (defaultPaymentType == null) {
      await setSetting(
        AppConstants.settingDefaultPaymentType,
        AppConstants.defaultPaymentTypeValue,
      );
    }

    if (autoBackup == null) {
      await setSetting(
        AppConstants.settingAutoBackup,
        AppConstants.defaultAutoBackup.toString(),
      );
    }

    if (notificationsEnabled == null) {
      await setSetting(
        AppConstants.settingNotificationsEnabled,
        AppConstants.defaultNotificationsEnabled.toString(),
      );
    }

    if (renewalReminderDays == null) {
      await setSetting(
        AppConstants.settingRenewalReminderDays,
        AppConstants.defaultRenewalReminderDays.toString(),
      );
    }
  }

  /// Ayar değerini getir
  Future<String?> getSetting(String key) async {
    final db = await _dbHelper.database;
    final result = await db.query(
      AppConstants.tableSettings,
      where: 'key = ?',
      whereArgs: [key],
      limit: 1,
    );

    if (result.isEmpty) return null;
    return result.first['value'] as String;
  }

  /// Ayar değerini kaydet
  Future<bool> setSetting(String key, String value) async {
    try {
      final db = await _dbHelper.database;
      
      // Önce ayarın var olup olmadığını kontrol et
      final existingValue = await getSetting(key);
      
      if (existingValue == null) {
        // Yeni ayar ekle
        await db.insert(
          AppConstants.tableSettings,
          {'key': key, 'value': value},
        );
      } else {
        // Mevcut ayarı güncelle
        await db.update(
          AppConstants.tableSettings,
          {'value': value},
          where: 'key = ?',
          whereArgs: [key],
        );
      }
      
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Karanlık mod ayarını getir
  Future<bool> getDarkMode() async {
    final darkMode = await getSetting(AppConstants.settingDarkMode);
    return darkMode == 'true';
  }

  /// Karanlık mod ayarını değiştir
  Future<bool> setDarkMode(bool value) async {
    return setSetting(AppConstants.settingDarkMode, value.toString());
  }

  /// Varsayılan üyelik süresi ayarını getir (gün olarak)
  Future<int> getDefaultMembershipDuration() async {
    final duration = await getSetting(AppConstants.settingDefaultMembershipDuration);
    return duration != null ? int.tryParse(duration) ?? AppConstants.defaultMembershipDurationDays : AppConstants.defaultMembershipDurationDays;
  }

  /// Varsayılan üyelik süresi ayarını değiştir
  Future<bool> setDefaultMembershipDuration(int days) async {
    return setSetting(AppConstants.settingDefaultMembershipDuration, days.toString());
  }

  /// Varsayılan ödeme tipi ayarını getir
  Future<String> getDefaultPaymentType() async {
    final paymentType = await getSetting(AppConstants.settingDefaultPaymentType);
    return paymentType ?? AppConstants.defaultPaymentTypeValue;
  }

  /// Varsayılan ödeme tipi ayarını değiştir
  Future<bool> setDefaultPaymentType(String type) async {
    return setSetting(AppConstants.settingDefaultPaymentType, type);
  }

  /// Otomatik yedekleme ayarını getir
  Future<bool> getAutoBackup() async {
    final autoBackup = await getSetting(AppConstants.settingAutoBackup);
    return autoBackup == 'true';
  }

  /// Otomatik yedekleme ayarını değiştir
  Future<bool> setAutoBackup(bool value) async {
    return setSetting(AppConstants.settingAutoBackup, value.toString());
  }

  /// Son yedekleme tarihini kaydet
  Future<bool> setLastBackupDate(DateTime date) async {
    return setSetting(
      AppConstants.settingLastBackupDate,
      date.millisecondsSinceEpoch.toString(),
    );
  }

  /// Son yedekleme tarihini getir
  Future<DateTime?> getLastBackupDate() async {
    final timestamp = await getSetting(AppConstants.settingLastBackupDate);
    if (timestamp == null) return null;
    
    final milliseconds = int.tryParse(timestamp);
    if (milliseconds == null) return null;
    
    return DateTime.fromMillisecondsSinceEpoch(milliseconds);
  }

  /// Bildirim ayarını getir
  Future<bool> getNotificationsEnabled() async {
    final enabled = await getSetting(AppConstants.settingNotificationsEnabled);
    return enabled == 'true';
  }

  /// Bildirim ayarını değiştir
  Future<bool> setNotificationsEnabled(bool value) async {
    return setSetting(AppConstants.settingNotificationsEnabled, value.toString());
  }

  /// Yenileme hatırlatması gün sayısını getir
  Future<int> getRenewalReminderDays() async {
    final days = await getSetting(AppConstants.settingRenewalReminderDays);
    return days != null ? int.tryParse(days) ?? AppConstants.defaultRenewalReminderDays : AppConstants.defaultRenewalReminderDays;
  }

  /// Yenileme hatırlatması gün sayısını değiştir
  Future<bool> setRenewalReminderDays(int days) async {
    return setSetting(AppConstants.settingRenewalReminderDays, days.toString());
  }
  
  /// Tüm ayarları getir
  Future<Map<String, String>> getAllSettings() async {
    final db = await _dbHelper.database;
    final result = await db.query(AppConstants.tableSettings);
    
    final Map<String, String> settings = {};
    for (final row in result) {
      final key = row['key'] as String;
      final value = row['value'] as String;
      settings[key] = value;
    }
    
    return settings;
  }
}