import '../datasources/local/database_helper.dart';
import '../models/payment.dart';
import '../../core/constants/app_constants.dart';

/// Ödemeler ile ilgili veritabanı işlemlerini yöneten repository sınıfı
class PaymentRepository {
  final DatabaseHelper _dbHelper;

  PaymentRepository(this._dbHelper);

  /// Tüm ödemeleri getir
  Future<List<Payment>> getAllPayments() async {
    final paymentMaps = await _dbHelper.getAll(AppConstants.tablePayments);
    return paymentMaps.map((map) => Payment.fromMap(map)).toList();
  }

  /// ID'ye göre ödeme getir
  Future<Payment?> getPaymentById(String paymentId) async {
    final paymentMap = await _dbHelper.getById(AppConstants.tablePayments, paymentId);
    if (paymentMap == null) return null;
    return Payment.fromMap(paymentMap);
  }

  /// Yeni ödeme ekle
  Future<bool> addPayment(Payment payment) async {
    try {
      await _dbHelper.insert(AppConstants.tablePayments, payment.toMap());
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Ödeme bilgilerini güncelle
  Future<bool> updatePayment(Payment payment) async {
    try {
      await _dbHelper.update(AppConstants.tablePayments, payment.toMap());
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Ödeme sil
  Future<bool> deletePayment(String paymentId) async {
    try {
      await _dbHelper.delete(AppConstants.tablePayments, paymentId);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Belirli bir üyenin ödemelerini getir
  Future<List<Payment>> getPaymentsByMemberId(String memberId) async {
    final db = await _dbHelper.database;
    final paymentMaps = await db.query(
      AppConstants.tablePayments,
      where: 'memberId = ?',
      whereArgs: [memberId],
      orderBy: 'paymentDate DESC',
    );
    return paymentMaps.map((map) => Payment.fromMap(map)).toList();
  }

  /// Belirli bir üyenin son ödemesini getir
  Future<Payment?> getLastPaymentByMemberId(String memberId) async {
    final db = await _dbHelper.database;
    final paymentMaps = await db.query(
      AppConstants.tablePayments,
      where: 'memberId = ?',
      whereArgs: [memberId],
      orderBy: 'paymentDate DESC',
      limit: 1,
    );
    if (paymentMaps.isEmpty) return null;
    return Payment.fromMap(paymentMaps.first);
  }

  /// Belirli bir tarih aralığındaki ödemeleri getir
  Future<List<Payment>> getPaymentsByDateRange(DateTime startDate, DateTime endDate) async {
    final db = await _dbHelper.database;
    final paymentMaps = await db.query(
      AppConstants.tablePayments,
      where: 'paymentDate BETWEEN ? AND ?',
      whereArgs: [startDate.millisecondsSinceEpoch, endDate.millisecondsSinceEpoch],
      orderBy: 'paymentDate DESC',
    );
    return paymentMaps.map((map) => Payment.fromMap(map)).toList();
  }

  /// Belirli bir ödeme tipine göre ödemeleri getir
  Future<List<Payment>> getPaymentsByType(String type) async {
    final db = await _dbHelper.database;
    final paymentMaps = await db.query(
      AppConstants.tablePayments,
      where: 'type = ?',
      whereArgs: [type],
      orderBy: 'paymentDate DESC',
    );
    return paymentMaps.map((map) => Payment.fromMap(map)).toList();
  }

  /// Belirli bir ödeme durumuna göre ödemeleri getir
  Future<List<Payment>> getPaymentsByStatus(String status) async {
    final db = await _dbHelper.database;
    final paymentMaps = await db.query(
      AppConstants.tablePayments,
      where: 'status = ?',
      whereArgs: [status],
      orderBy: 'paymentDate DESC',
    );
    return paymentMaps.map((map) => Payment.fromMap(map)).toList();
  }

  /// Toplam ödeme sayısını getir
  Future<int> getPaymentCount() async {
    final db = await _dbHelper.database;
    final result = await db.rawQuery('SELECT COUNT(*) as count FROM ${AppConstants.tablePayments}');
    return Sqflite.firstIntValue(result) ?? 0;
  }

  /// Belirli bir tarih aralığındaki toplam geliri hesapla
  Future<double> getTotalIncomeForDateRange(DateTime startDate, DateTime endDate) async {
    final db = await _dbHelper.database;
    final result = await db.rawQuery(
      '''
      SELECT SUM(amount) as total FROM ${AppConstants.tablePayments}
      WHERE paymentDate BETWEEN ? AND ?
      AND status = ?
      ''',
      [
        startDate.millisecondsSinceEpoch,
        endDate.millisecondsSinceEpoch,
        AppConstants.paymentStatusPaid,
      ],
    );
    return result.isNotEmpty && result.first['total'] != null
        ? (result.first['total'] as num).toDouble()
        : 0.0;
  }

  /// Bugünkü toplam geliri hesapla
  Future<double> getTodayIncome() async {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59);
    return getTotalIncomeForDateRange(startOfDay, endOfDay);
  }

  /// Son aya ait toplam geliri hesapla
  Future<double> getMonthlyIncome() async {
    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);
    final endOfMonth = DateTime(now.year, now.month + 1, 0, 23, 59, 59);
    return getTotalIncomeForDateRange(startOfMonth, endOfMonth);
  }

  /// Yıllık toplam geliri hesapla
  Future<double> getYearlyIncome() async {
    final now = DateTime.now();
    final startOfYear = DateTime(now.year, 1, 1);
    final endOfYear = DateTime(now.year, 12, 31, 23, 59, 59);
    return getTotalIncomeForDateRange(startOfYear, endOfYear);
  }

  /// Aylara göre gelir raporu oluştur
  Future<Map<String, double>> getMonthlyIncomeReport(int year) async {
    final Map<String, double> monthlyIncomes = {};
    
    for (int month = 1; month <= 12; month++) {
      final startOfMonth = DateTime(year, month, 1);
      final endOfMonth = DateTime(year, month + 1, 0, 23, 59, 59);
      
      final income = await getTotalIncomeForDateRange(startOfMonth, endOfMonth);
      final monthName = _getMonthName(month);
      
      monthlyIncomes[monthName] = income;
    }
    
    return monthlyIncomes;
  }

  // Ay numarasına göre ay ismi getir
  String _getMonthName(int month) {
    const Map<int, String> monthNames = {
      1: 'Ocak',
      2: 'Şubat',
      3: 'Mart',
      4: 'Nisan',
      5: 'Mayıs',
      6: 'Haziran',
      7: 'Temmuz',
      8: 'Ağustos',
      9: 'Eylül',
      10: 'Ekim',
      11: 'Kasım',
      12: 'Aralık',
    };
    
    return monthNames[month] ?? '';
  }
}