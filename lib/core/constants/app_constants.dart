/// Uygulama genelinde kullanılan sabit değerler
class AppConstants {
  // Uygulama sürüm bilgileri
  static const String appVersion = '1.0.0';
  static const int appBuildNumber = 1;
  
  // Veritabanı sabitleri
  static const String dbName = 'ms_fitness.db';
  static const int dbVersion = 1;
  static const String tableMembers = 'members';
  static const String tablePayments = 'payments';
  static const String tableSettings = 'settings';
  
  // Ayarlar anahtarları
  static const String settingDarkMode = 'dark_mode';
  static const String settingDefaultMembershipDuration = 'default_membership_duration';
  static const String settingDefaultPaymentType = 'default_payment_type';
  static const String settingAutoBackup = 'auto_backup';
  static const String settingLastBackupDate = 'last_backup_date';
  static const String settingNotificationsEnabled = 'notifications_enabled';
  static const String settingRenewalReminderDays = 'renewal_reminder_days';
  
  // Üye durumları
  static const String statusActive = 'active';
  static const String statusInactive = 'inactive';
  static const String statusPending = 'pending';
  
  // Ödeme tipleri
  static const String paymentTypeNew = 'new';
  static const String paymentTypeRenewal = 'renewal';
  static const String paymentTypeDiscount = 'discount';
  static const String paymentTypeOther = 'other';
  
  // Ödeme durumları
  static const String paymentStatusPaid = 'paid';
  static const String paymentStatusPending = 'pending';
  static const String paymentStatusPartial = 'partial';
  static const String paymentStatusRefunded = 'refunded';
  
  // Ödeme yöntemleri
  static const String paymentMethodCash = 'cash';
  static const String paymentMethodCard = 'card';
  static const String paymentMethodTransfer = 'transfer';
  static const String paymentMethodOther = 'other';
  
  // Yönlendirme rotaları
  static const String routeSplash = '/splash';
  static const String routeIntro = '/intro';
  static const String routeHome = '/home';
  static const String routeMembers = '/members';
  static const String routeMemberDetail = '/member_detail';
  static const String routeAddMember = '/add_member';
  static const String routeEditMember = '/edit_member';
  static const String routePayments = '/payments';
  static const String routeAddPayment = '/add_payment';
  static const String routeReports = '/reports';
  static const String routeQrScanner = '/qr_scanner';
  static const String routeQrGenerator = '/qr_generator';
  static const String routeSettings = '/settings';
  
  // Dosya yolları
  static const String backupFolder = 'backups';
  static const String profileImagesFolder = 'profile_images';
  static const String tempFolder = 'temp';
  
  // API endpoints (gelecekte kullanılacak)
  static const String apiBaseUrl = 'https://api.msfitness.com';
  static const String apiLogin = '/auth/login';
  static const String apiRegister = '/auth/register';
  static const String apiSync = '/sync';
  
  // Zamanlayıcı değerleri
  static const int backupIntervalDays = 7;
  static const int autoSaveIntervalMinutes = 30;
  static const List<int> reminderDaysOptions = [1, 3, 7, 14, 30];
  
  // Varsayılan ayarlar
  static const bool defaultDarkMode = true;
  static const int defaultMembershipDurationDays = 30;
  static const String defaultPaymentTypeValue = paymentTypeRenewal;
  static const bool defaultAutoBackup = true;
  static const bool defaultNotificationsEnabled = true;
  static const int defaultRenewalReminderDays = 7;
  
  // Uygulama genelinde geçerli formatlar
  static const String dateFormatDisplay = 'dd.MM.yyyy';
  static const String dateTimeFormatDisplay = 'dd.MM.yyyy HH:mm';
  static const String currencySymbol = '₺';
  
  // Üyelik süresi seçenekleri (gün)
  static const Map<String, int> membershipDurationOptions = {
    'Günlük': 1,
    'Haftalık': 7,
    'Aylık': 30,
    '3 Aylık': 90,
    '6 Aylık': 180,
    'Yıllık': 365,
  };
  
  // Yenileme hatırlatma eşiği (gün)
  static const int membershipRenewalThresholdDays = 7;
}