import '../datasources/local/database_helper.dart';
import '../models/member.dart';
import '../../core/constants/app_constants.dart';

/// Üyeler ile ilgili veritabanı işlemlerini yöneten repository sınıfı
class MemberRepository {
  final DatabaseHelper _dbHelper;

  MemberRepository(this._dbHelper);

  /// Tüm üyeleri getir
  Future<List<Member>> getAllMembers() async {
    final memberMaps = await _dbHelper.getAll(AppConstants.tableMembers);
    return memberMaps.map((map) => Member.fromMap(map)).toList();
  }

  /// ID'ye göre üye getir
  Future<Member?> getMemberById(String memberId) async {
    final memberMap = await _dbHelper.getById(AppConstants.tableMembers, memberId);
    if (memberMap == null) return null;
    return Member.fromMap(memberMap);
  }

  /// Yeni üye ekle
  Future<bool> addMember(Member member) async {
    try {
      await _dbHelper.insert(AppConstants.tableMembers, member.toMap());
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Üye bilgilerini güncelle
  Future<bool> updateMember(Member member) async {
    try {
      await _dbHelper.update(AppConstants.tableMembers, member.toMap());
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Üye sil
  Future<bool> deleteMember(String memberId) async {
    try {
      await _dbHelper.delete(AppConstants.tableMembers, memberId);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Sadece aktif üyeleri getir
  Future<List<Member>> getActiveMembers() async {
    final db = await _dbHelper.database;
    final memberMaps = await db.query(
      AppConstants.tableMembers,
      where: 'status = ?',
      whereArgs: [AppConstants.statusActive],
    );
    return memberMaps.map((map) => Member.fromMap(map)).toList();
  }

  /// Sadece pasif üyeleri getir
  Future<List<Member>> getInactiveMembers() async {
    final db = await _dbHelper.database;
    final memberMaps = await db.query(
      AppConstants.tableMembers,
      where: 'status = ?',
      whereArgs: [AppConstants.statusInactive],
    );
    return memberMaps.map((map) => Member.fromMap(map)).toList();
  }

  /// Ada göre üye ara
  Future<List<Member>> searchMembersByName(String query) async {
    final db = await _dbHelper.database;
    final memberMaps = await db.query(
      AppConstants.tableMembers,
      where: 'fullName LIKE ?',
      whereArgs: ['%$query%'],
    );
    return memberMaps.map((map) => Member.fromMap(map)).toList();
  }

  /// Üyeliği yakında bitecek üyeleri getir
  Future<List<Member>> getMembersWithExpiringMembership() async {
    final now = DateTime.now();
    final threshold = now.add(Duration(days: AppConstants.membershipRenewalThresholdDays));
    
    // Ödeme tablosundan yakında bitecek üyelikleri bul
    final query = '''
      SELECT m.* FROM ${AppConstants.tableMembers} m
      INNER JOIN ${AppConstants.tablePayments} p
      ON m.id = p.memberId
      WHERE p.expiryDate BETWEEN ${now.millisecondsSinceEpoch} AND ${threshold.millisecondsSinceEpoch}
      AND m.status = '${AppConstants.statusActive}'
      GROUP BY m.id
    ''';
    
    final memberMaps = await _dbHelper.rawQuery(query);
    return memberMaps.map((map) => Member.fromMap(map)).toList();
  }

  /// Üyelikleri süresi dolmuş üyeleri getir
  Future<List<Member>> getMembersWithExpiredMembership() async {
    final now = DateTime.now().millisecondsSinceEpoch;
    
    // Ödeme tablosundan süresi dolmuş üyelikleri bul
    final query = '''
      SELECT m.* FROM ${AppConstants.tableMembers} m
      INNER JOIN ${AppConstants.tablePayments} p
      ON m.id = p.memberId
      WHERE p.expiryDate < $now
      AND m.status = '${AppConstants.statusActive}'
      GROUP BY m.id
    ''';
    
    final memberMaps = await _dbHelper.rawQuery(query);
    return memberMaps.map((map) => Member.fromMap(map)).toList();
  }

  /// Üye sayısını getir
  Future<int> getMemberCount() async {
    final db = await _dbHelper.database;
    final result = await db.rawQuery('SELECT COUNT(*) as count FROM ${AppConstants.tableMembers}');
    return Sqflite.firstIntValue(result) ?? 0;
  }

  /// Aktif üye sayısını getir
  Future<int> getActiveMemberCount() async {
    final db = await _dbHelper.database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM ${AppConstants.tableMembers} WHERE status = ?',
      [AppConstants.statusActive],
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }
}