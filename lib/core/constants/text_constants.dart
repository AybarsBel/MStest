/// Uygulamada kullanılan statik metin sabitleri
class TextConstants {
  // Genel metinler
  static const String appTitle = 'MS Fitness';
  static const String appSubtitle = 'Üye Yönetim Sistemi';
  
  // Giriş ekranı metinleri
  static const String loginTitle = 'MS Fitness';
  static const String loginSubtitle = 'Üye Takip Sistemine Hoş Geldiniz';
  static const String loginButton = 'Giriş Yap';
  static const String loginWithPin = 'PIN ile Giriş';
  static const String forgotPassword = 'Şifremi Unuttum';
  
  // Ana ekran metinleri
  static const String homeTitle = 'Ana Sayfa';
  static const String totalMembers = 'Toplam Üye';
  static const String activeMembers = 'Aktif Üye';
  static const String pendingRenewals = 'Yenileme Bekleyen';
  static const String monthlyIncome = 'Aylık Gelir';
  
  // Üyeler ekranı metinleri
  static const String membersTitle = 'Üyeler';
  static const String membersSubtitle = 'Tüm Üyeleri Yönet';
  static const String addMember = 'Üye Ekle';
  static const String editMember = 'Üye Düzenle';
  static const String memberDetails = 'Üye Detayları';
  static const String searchMembers = 'Üye Ara';
  static const String allMembers = 'Tüm Üyeler';
  static const String activeOnly = 'Sadece Aktif';
  static const String inactiveOnly = 'Sadece Pasif';
  static const String renewalsList = 'Yenileme Listesi';
  
  // Üye form metinleri
  static const String memberName = 'Ad Soyad';
  static const String memberPhone = 'Telefon Numarası';
  static const String memberEmail = 'E-posta';
  static const String memberBirthdate = 'Doğum Tarihi';
  static const String memberStartDate = 'Başlangıç Tarihi';
  static const String membershipType = 'Üyelik Tipi';
  static const String memberStatus = 'Durum';
  static const String memberNotes = 'Notlar';
  static const String memberProfilePhoto = 'Profil Fotoğrafı';
  static const String membershipDuration = 'Üyelik Süresi';
  static const String membershipExpiryDate = 'Bitiş Tarihi';
  static const String membershipDaysLeft = 'Kalan Gün';
  static const String membershipValid = 'Üyelik Geçerli';
  static const String membershipExpired = 'Üyelik Süresi Dolmuş';
  static const String takePhoto = 'Fotoğraf Çek';
  static const String selectFromGallery = 'Galeriden Seç';
  static const String removePhoto = 'Fotoğrafı Kaldır';
  
  // Üye detay metinleri
  static const String lastPayment = 'Son Ödeme';
  static const String paymentHistory = 'Ödeme Geçmişi';
  static const String activateDeactivate = 'Aktif/Pasif Yap';
  static const String generateQrCode = 'QR Kod Oluştur';
  static const String sendReminderSms = 'SMS ile Hatırlat';
  static const String sendReminderEmail = 'E-posta ile Hatırlat';
  static const String viewAllPayments = 'Tüm Ödemeleri Gör';
  
  // Ödeme ekranı metinleri
  static const String paymentsTitle = 'Ödemeler';
  static const String paymentsSubtitle = 'Ödeme İşlemleri';
  static const String addPayment = 'Ödeme Ekle';
  static const String editPayment = 'Ödeme Düzenle';
  static const String paymentDetails = 'Ödeme Detayları';
  static const String allPayments = 'Tüm Ödemeler';
  static const String selectMember = 'Üye Seç';
  static const String paymentAmount = 'Ödeme Tutarı';
  static const String paymentDate = 'Ödeme Tarihi';
  static const String paymentType = 'Ödeme Tipi';
  static const String paymentStatus = 'Ödeme Durumu';
  static const String paymentDescription = 'Açıklama';
  static const String paymentMethod = 'Ödeme Yöntemi';
  static const String filterPayments = 'Ödemeleri Filtrele';
  static const String dateRange = 'Tarih Aralığı';
  
  // Rapor ekranı metinleri
  static const String reportsTitle = 'Raporlar';
  static const String reportsSubtitle = 'Gelir & Üye İstatistikleri';
  static const String membersReport = 'Üye Raporu';
  static const String incomeReport = 'Gelir Raporu';
  static const String membershipReport = 'Üyelik Raporu';
  static const String dailyReport = 'Günlük Rapor';
  static const String weeklyReport = 'Haftalık Rapor';
  static const String monthlyReport = 'Aylık Rapor';
  static const String yearlyReport = 'Yıllık Rapor';
  static const String customDateReport = 'Özel Tarih Raporu';
  static const String startDate = 'Başlangıç Tarihi';
  static const String endDate = 'Bitiş Tarihi';
  static const String exportReport = 'Dışa Aktar';
  
  // QR kod ekranı metinleri
  static const String qrCodeTitle = 'QR Kod';
  static const String qrCodeSubtitle = 'Üye QR Kodu';
  static const String scanQrCode = 'QR Kod Tara';
  static const String saveQrCode = 'QR Kodu Kaydet';
  static const String shareQrCode = 'QR Kodu Paylaş';
  static const String qrCodeDescription = 'Üye girişi için QR kodu taratın';
  
  // Ayarlar ekranı metinleri
  static const String settingsTitle = 'Ayarlar';
  static const String settingsSubtitle = 'Uygulama Ayarları';
  static const String darkMode = 'Koyu Tema';
  static const String language = 'Dil';
  static const String notifications = 'Bildirimler';
  static const String backup = 'Yedekleme';
  static const String restore = 'Geri Yükleme';
  static const String createBackup = 'Yedek Oluştur';
  static const String restoreBackup = 'Yedeği Geri Yükle';
  static const String autoBackup = 'Otomatik Yedekleme';
  static const String defaultDuration = 'Varsayılan Süre';
  static const String defaultPaymentType = 'Varsayılan Ödeme Tipi';
  static const String syncWithCloud = 'Bulut ile Senkronize Et';
  static const String aboutApp = 'Uygulama Hakkında';
  static const String version = 'Versiyon';
  static const String contactUs = 'İletişim';
  
  // Bildirim metinleri
  static const String renewalReminder = 'Üyelik Yenileme Hatırlatması';
  static const String renewalReminderMessage = 'üyelik süreniz yakında dolacak.';
  static const String daysLeft = 'gün kaldı.';
  static const String paymentReminder = 'Ödeme Hatırlatması';
  static const String backupReminder = 'Yedekleme Hatırlatması';
  
  // Dialog metinleri
  static const String confirmTitle = 'Onay';
  static const String errorTitle = 'Hata';
  static const String warningTitle = 'Uyarı';
  static const String successTitle = 'Başarılı';
  static const String infoTitle = 'Bilgi';
  static const String confirm = 'Onayla';
  static const String cancel = 'İptal';
  static const String ok = 'Tamam';
  static const String yes = 'Evet';
  static const String no = 'Hayır';
  static const String delete = 'Sil';
  static const String edit = 'Düzenle';
  static const String save = 'Kaydet';
  static const String continue_ = 'Devam Et';
  static const String deleteConfirmation = 'Silmek istediğinize emin misiniz?';
  
  // Hata metinleri
  static const String errorRequired = 'Bu alan zorunludur';
  static const String errorInvalidEmail = 'Geçerli bir e-posta adresi giriniz';
  static const String errorInvalidPhone = 'Geçerli bir telefon numarası giriniz';
  static const String errorInvalidDate = 'Geçerli bir tarih giriniz';
  static const String errorGeneric = 'Bir hata oluştu';
  static const String errorConnection = 'Bağlantı hatası';
  static const String errorNotFound = 'Bulunamadı';
  
  // Boş durum metinleri
  static const String emptyMembers = 'Henüz kayıtlı üye bulunmuyor';
  static const String emptyPayments = 'Henüz kayıtlı ödeme bulunmuyor';
  static const String emptySearch = 'Arama sonucu bulunamadı';
  static const String emptyRenewals = 'Yenileme bekleyen üye bulunmuyor';
}