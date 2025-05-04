/// Form alanlarındaki verilerin doğruluğunu kontrol etmek için kullanılan sınıf
class Validators {
  // Boş string kontrolü
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName alanı zorunludur';
    }
    return null;
  }
  
  // Telefon numarası formatı kontrolü (Türkiye)
  static String? validatePhoneNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null; // Zorunlu değilse boş geçilebilir
    }
    
    // Türkiye telefon formatı: 05XX XXX XXXX
    final phoneRegExp = RegExp(r'^(05)([0-9]{2})([0-9]{3})([0-9]{2})([0-9]{2})$');
    
    String cleanPhone = value.replaceAll(RegExp(r'[\s\-\(\)]'), '');
    
    if (!phoneRegExp.hasMatch(cleanPhone)) {
      return 'Geçerli bir telefon numarası giriniz (05XX XXX XXXX)';
    }
    
    return null;
  }
  
  // Ödeme tutarı kontrolü
  static String? validatePaymentAmount(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Ödeme tutarı zorunludur';
    }
    
    double? amount;
    try {
      amount = double.parse(value.replaceAll(',', '.'));
    } catch (e) {
      return 'Geçerli bir tutar giriniz';
    }
    
    if (amount <= 0) {
      return 'Tutar 0\'dan büyük olmalıdır';
    }
    
    return null;
  }
  
  // E-posta formatı kontrolü
  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null; // Zorunlu değilse boş geçilebilir
    }
    
    final emailRegExp = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    
    if (!emailRegExp.hasMatch(value)) {
      return 'Geçerli bir e-posta adresi giriniz';
    }
    
    return null;
  }
  
  // Tarih formatı kontrolü (dd/MM/yyyy)
  static String? validateDate(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null; // Zorunlu değilse boş geçilebilir
    }
    
    // Girilen tarih formatı kontrolü: dd/MM/yyyy
    final dateRegExp = RegExp(
      r'^(0[1-9]|[12][0-9]|3[01])\/(0[1-9]|1[012])\/\d{4}$',
    );
    
    if (!dateRegExp.hasMatch(value)) {
      return 'Geçerli bir tarih giriniz (GG/AA/YYYY)';
    }
    
    // Girilen tarihin gerçekte var olup olmadığı kontrolü
    try {
      final parts = value.split('/');
      final day = int.parse(parts[0]);
      final month = int.parse(parts[1]);
      final year = int.parse(parts[2]);
      
      final date = DateTime(year, month, day);
      
      // Girilen gün, başka bir aya geçtiyse (örn: 31/04/2023 -> Nisan'da 31 gün yok)
      if (date.day != day) {
        return 'Geçerli bir tarih giriniz (GG/AA/YYYY)';
      }
    } catch (e) {
      return 'Geçerli bir tarih giriniz (GG/AA/YYYY)';
    }
    
    return null;
  }
}