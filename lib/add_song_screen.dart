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

  Future<void> _saveSong() async {
    final song = {
      'title': titleController.text,
      'artist': artistController.text,
      'album': albumController.text,
      'path': pathController.text,
    };
    await DatabaseHelper.instance.insertSong(song);

    if (mounted) {
      Navigator.pop(context);
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
