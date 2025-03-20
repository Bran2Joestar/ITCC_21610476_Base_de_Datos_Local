import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;

  DatabaseHelper._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'songs.db');
    return await openDatabase(
      path,
      version: 2, // Asegúrate de incrementar la versión
      onCreate: _createDatabase,
      onUpgrade: _upgradeDatabase,
    );
  }

  Future<void> _createDatabase(Database db, int version) async {
    await db.execute('''
      CREATE TABLE songs (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        artist TEXT,
        album TEXT,
        path TEXT,
        photo TEXT,  
        likes INTEGER DEFAULT 0  
      )
    ''');
  }

  Future<void> _upgradeDatabase(
    Database db,
    int oldVersion,
    int newVersion,
  ) async {
    if (oldVersion < 2) {
      await db.execute('''
        ALTER TABLE songs ADD COLUMN photo TEXT
      ''');
      await db.execute('''
        ALTER TABLE songs ADD COLUMN likes INTEGER DEFAULT 0
      ''');
    }
  }

  Future<List<Map<String, dynamic>>> fetchSongs() async {
    final db = await instance.database;
    return await db.query('songs');
  }

  Future<int> insertSong(Map<String, dynamic> row) async {
    final db = await instance.database;
    return await db.insert('songs', row);
  }

  Future<int> updateSong(Map<String, dynamic> row) async {
    final db = await instance.database;
    return await db.update(
      'songs',
      row,
      where: 'id = ?',
      whereArgs: [row['id']],
    );
  }

  Future<int> deleteSong(String id) async {
    final db = await instance.database;
    return await db.delete('songs', where: 'id = ?', whereArgs: [id]);
  }
}
