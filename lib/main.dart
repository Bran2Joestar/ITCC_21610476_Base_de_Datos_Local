import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

void main() {
  runApp(const MusicPlayerApp());
}

class MusicPlayerApp extends StatelessWidget {
  const MusicPlayerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Music Player',
      theme: ThemeData.dark(),
      initialRoute: '/',
      routes: {
        '/': (context) => const SongListScreen(),
        '/add': (context) => const AddSongScreen(),
        '/player': (context) => const PlayerScreen(),
      },
    );
  }
}

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

  Future<int> insertSong(Map<String, dynamic> row) async {
    final db = await instance.database;
    return await db.insert('songs', row);
  }

  Future<List<Map<String, dynamic>>> fetchSongs() async {
    final db = await instance.database;
    return await db.query('songs');
  }
}

// Pantalla principal - Lista de canciones
class SongListScreen extends StatefulWidget {
  const SongListScreen({super.key});

  @override
  _SongListScreenState createState() => _SongListScreenState();
}

class _SongListScreenState extends State<SongListScreen> {
  List<Map<String, dynamic>> _songs = [];

  @override
  void initState() {
    super.initState();
    _loadSongs();
  }

  Future<void> _loadSongs() async {
    final songs = await DatabaseHelper.instance.fetchSongs();
    setState(() {
      _songs = songs;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lista de Canciones')),
      body: ListView.builder(
        itemCount: _songs.length,
        itemBuilder: (context, index) {
          final song = _songs[index];
          return ListTile(
            title: Text(song['title']),
            subtitle: Text(song['artist']),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.pushNamed(context, '/add');
          _loadSongs();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

// Pantalla para añadir canciones
class AddSongScreen extends StatefulWidget {
  const AddSongScreen({super.key});

  @override
  _AddSongScreenState createState() => _AddSongScreenState();
}

class _AddSongScreenState extends State<AddSongScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController artistController = TextEditingController();
  final TextEditingController albumController = TextEditingController();
  final TextEditingController pathController = TextEditingController();

  Future<void> _saveSong() async {
    final song = {
      'title': titleController.text,
      'artist': artistController.text,
      'album': albumController.text,
      'path': pathController.text,
    };
    await DatabaseHelper.instance.insertSong(song);

    if (mounted) {
      Navigator.pop(context as BuildContext);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Añadir Canción')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Título'),
            ),
            TextField(
              controller: artistController,
              decoration: const InputDecoration(labelText: 'Artista'),
            ),
            TextField(
              controller: albumController,
              decoration: const InputDecoration(labelText: 'Álbum'),
            ),
            TextField(
              controller: pathController,
              decoration: const InputDecoration(
                labelText: 'Ubicación del archivo',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: _saveSong, child: const Text('Guardar')),
          ],
        ),
      ),
    );
  }
}

// Pantalla de reproducción
class PlayerScreen extends StatelessWidget {
  const PlayerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reproduciendo')),
      body: const Center(child: Text('Datos de la canción en reproducción')),
    );
  }
}
