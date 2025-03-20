import 'dart:io'; // Asegúrate de importar esta librería
import 'package:flutter/material.dart';
import 'database_helper.dart';

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

  void _likeSong(String title) {
    print('Liked: $title');
  }

  Future<void> _editSong(Map<String, dynamic> song) async {
    await Navigator.pushNamed(context, '/edit', arguments: song);
    _loadSongs(); // Recargar canciones después de la edición
  }

  Future<void> _deleteSong(String id) async {
    await DatabaseHelper.instance.deleteSong(id);
    _loadSongs(); // Recargar canciones después de la eliminación
  }

  void _playSong(Map<String, dynamic> song) {
    Navigator.pushNamed(
      context,
      '/player',
      arguments: {
        'title': song['title'],
        'artist': song['artist'],
        'album': song['album'],
        'path': song['path'],
        'photo': song['photo'], // Añadir la foto
        'likes': song['likes'], // Añadir los likes
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lista de Canciones')),
      body: ListView.builder(
        itemCount: _songs.length,
        itemBuilder: (context, index) {
          final song = _songs[index];
          String imagePath = song['photo'];

          // Verificar si el archivo de imagen existe
          bool imageExists = File(imagePath).existsSync();

          return Card(
            margin: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () => _playSong(song),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    // Cargar la imagen o mostrar un icono de error si no existe
                    imageExists
                        ? Image.file(File(imagePath), width: 50, height: 50)
                        : Icon(
                          Icons.error,
                          size: 50,
                          color: Colors.red,
                        ), // Icono si no existe la imagen
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            song['title'],
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(song['artist']),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.thumb_up),
                          onPressed: () => _likeSong(song['title']),
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => _editSong(song),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () async {
                            await _deleteSong(song['id'].toString());
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.pushNamed(context, '/add');
          _loadSongs(); // Recargar canciones después de agregar
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
