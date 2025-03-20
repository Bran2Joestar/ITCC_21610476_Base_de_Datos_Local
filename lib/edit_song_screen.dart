import 'package:flutter/material.dart';
import 'database_helper.dart';

class EditSongScreen extends StatefulWidget {
  const EditSongScreen({super.key});

  @override
  _EditSongScreenState createState() => _EditSongScreenState();
}

class _EditSongScreenState extends State<EditSongScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController artistController = TextEditingController();
  final TextEditingController albumController = TextEditingController();
  final TextEditingController pathController = TextEditingController();
  final TextEditingController photoController =
      TextEditingController(); // Para la ubicación de la foto

  int? songId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    songId = args['id'];
    titleController.text = args['title'];
    artistController.text = args['artist'];
    albumController.text = args['album'];
    pathController.text = args['path'];
    photoController.text = args['photo']; // Cargar la ubicación de la foto
  }

  Future<void> _updateSong() async {
    final song = {
      'id': songId,
      'title': titleController.text,
      'artist': artistController.text,
      'album': albumController.text,
      'path': pathController.text,
      'photo': photoController.text, // Agregar la ubicación de la foto
      'likes': 0, // Mantener el valor de likes
    };
    await DatabaseHelper.instance.updateSong(song);
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Editar Canción')),
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
            ElevatedButton(
              onPressed: _updateSong,
              child: const Text('Guardar Cambios'),
            ),
          ],
        ),
      ),
    );
  }
}
