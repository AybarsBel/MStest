import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class AppDatabase {
  static final AppDatabase _instance = AppDatabase._internal();
  static Database? _database;

  factory AppDatabase() {
    return _instance;
  }

  AppDatabase._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'ms_fitness.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createTables,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _createTables(Database db, int version) async {
    // Üyeler tablosu
    await db.execute('''
      CREATE TABLE members (
        id TEXT PRIMARY KEY,
        fullName TEXT NOT NULL,
        birthDate TEXT,
        phoneNumber TEXT,
        bloodType TEXT,
        registrationDate TEXT NOT NULL,
        profileImagePath TEXT,
        status TEXT NOT NULL,
        isActive INTEGER NOT NULL DEFAULT 1
      )
    ''');

    // Ödemeler tablosu
    await db.execute('''
      CREATE TABLE payments (
        id TEXT PRIMARY KEY,
        memberId TEXT NOT NULL,
        amount REAL NOT NULL,
        paymentDate TEXT NOT NULL,
        expiryDate TEXT NOT NULL,
        FOREIGN KEY (memberId) REFERENCES members (id) ON DELETE CASCADE
      )
    ''');

    // Ayarlar tablosu
    await db.execute('''
      CREATE TABLE settings (
        key TEXT PRIMARY KEY,
        value TEXT NOT NULL
      )
    ''');

    // Varsayılan ayarları ekle
    await db.insert('settings', {
      'key': 'membershipFee',
      'value': '800.0'
    });
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Gelecekte veritabanı yapısı değişirse burada güncelleme yapılacak
    if (oldVersion < 2) {
      // Versiyon 2 için gerekli güncellemeler
    }
  }

  Future<void> closeDatabase() async {
    if (_database != null && _database!.isOpen) {
      await _database!.close();
      _database = null;
    }
  }
}
