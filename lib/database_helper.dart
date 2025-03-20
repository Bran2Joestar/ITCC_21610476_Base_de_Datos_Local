import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('songs.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE songs (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            artist TEXT,
            album TEXT,
            path TEXT
          )
        ''');
      },
    );
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

  Future<int> insertSong(Map<String, dynamic> row) async {
    final db = await instance.database;
    return await db.insert('songs', row);
  }

  Future<List<Map<String, dynamic>>> fetchSongs() async {
    final db = await instance.database;
    return await db.query('songs');
  }
}
