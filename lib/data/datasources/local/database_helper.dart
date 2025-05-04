import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../../../core/constants/app_constants.dart';

/// Veritabanı işlemlerini yönetmek için yardımcı sınıf
class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  
  factory DatabaseHelper() => _instance;
  
  DatabaseHelper._internal();
  
  Database? _database;
  
  // Veritabanı bağlantısını al; yok ise oluştur
  Future<Database> get database async {
    if (_database != null) return _database!;
    
    _database = await _initDatabase();
    return _database!;
  }
  
  // Veritabanını başlat
  Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, AppConstants.dbName);
    
    return await openDatabase(
      path,
      version: AppConstants.dbVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }
  
  // Veritabanını oluştur
  Future<void> _onCreate(Database db, int version) async {
    // Üye tablosu
    await db.execute('''
      CREATE TABLE ${AppConstants.tableMembers} (
        id TEXT PRIMARY KEY,
        fullName TEXT NOT NULL,
        phoneNumber TEXT,
        email TEXT,
        birthDate INTEGER,
        startDate INTEGER NOT NULL,
        status TEXT NOT NULL,
        notes TEXT,
        profileImagePath TEXT,
        createdAt INTEGER NOT NULL,
        updatedAt INTEGER NOT NULL
      )
    ''');
    
    // Ödeme tablosu
    await db.execute('''
      CREATE TABLE ${AppConstants.tablePayments} (
        id TEXT PRIMARY KEY,
        memberId TEXT NOT NULL,
        amount REAL NOT NULL,
        paymentDate INTEGER NOT NULL,
        expiryDate INTEGER NOT NULL,
        type TEXT NOT NULL,
        status TEXT NOT NULL,
        description TEXT,
        paymentMethod TEXT,
        createdAt INTEGER NOT NULL,
        updatedAt INTEGER NOT NULL,
        FOREIGN KEY (memberId) REFERENCES ${AppConstants.tableMembers} (id) ON DELETE CASCADE
      )
    ''');
    
    // Ayarlar tablosu
    await db.execute('''
      CREATE TABLE ${AppConstants.tableSettings} (
        key TEXT PRIMARY KEY,
        value TEXT NOT NULL
      )
    ''');
  }
  
  // Veritabanı sürüm yükseltme
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // İleride sürüm yükseltme işlemleri burada yapılacak
    if (oldVersion < 2) {
      // Sürüm 2'ye yükseltme işlemleri
    }
  }
  
  // Veri ekleme
  Future<int> insert(String table, Map<String, dynamic> data) async {
    final db = await database;
    return await db.insert(table, data, conflictAlgorithm: ConflictAlgorithm.replace);
  }
  
  // Veri güncelleme
  Future<int> update(String table, Map<String, dynamic> data) async {
    final db = await database;
    final id = data['id'];
    return await db.update(
      table,
      data,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
  
  // Veri silme
  Future<int> delete(String table, String id) async {
    final db = await database;
    return await db.delete(
      table,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
  
  // Tüm verileri getir
  Future<List<Map<String, dynamic>>> getAll(String table) async {
    final db = await database;
    return await db.query(table);
  }
  
  // ID'ye göre veri getir
  Future<Map<String, dynamic>?> getById(String table, String id) async {
    final db = await database;
    final results = await db.query(
      table,
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    
    return results.isNotEmpty ? results.first : null;
  }
  
  // Birden çok tabloyu içeren karmaşık sorgu
  Future<List<Map<String, dynamic>>> rawQuery(String sql, [List<dynamic>? arguments]) async {
    final db = await database;
    return await db.rawQuery(sql, arguments);
  }
  
  // Veritabanı yedekle (dosya olarak)
  Future<String> backupDatabase() async {
    final db = await database;
    await db.close();
    
    final databasesPath = await getDatabasesPath();
    final dbPath = join(databasesPath, AppConstants.dbName);
    
    // Buraya yedekleme kodu gelecek
    
    _database = null; // Yeniden bağlanabilmek için
    
    return dbPath;
  }
  
  // Veritabanını geri yükle
  Future<bool> restoreDatabase(String backupPath) async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
    
    try {
      // Buraya geri yükleme kodu gelecek
      
      return true;
    } catch (e) {
      return false;
    }
  }
  
  // Veritabanını kapat
  Future<void> close() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }
}