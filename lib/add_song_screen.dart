import 'package:flutter/material.dart';
import 'database_helper.dart';

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
  final TextEditingController photoController =
      TextEditingController(); // Para la ubicación de la foto

  Future<void> _addSong() async {
    final song = {
      'title': titleController.text,
      'artist': artistController.text,
      'album': albumController.text,
      'path': pathController.text,
      'photo': photoController.text, // Agregar la ubicación de la foto
      'likes': 0, // Por defecto
    };
    await DatabaseHelper.instance.insertSong(song);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Agregar Canción')),
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
            TextField(
              controller: photoController,
              decoration: const InputDecoration(
                labelText: 'Ubicación de la foto',
              ), // Campo para la foto
            ),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: _addSong, child: const Text('Agregar')),
          ],
        ),
      ),
    );
  }
}
