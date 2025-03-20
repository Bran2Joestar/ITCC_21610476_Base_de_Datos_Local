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
  }

  Future<void> _updateSong() async {
    final song = {
      'id': songId,
      'title': titleController.text,
      'artist': artistController.text,
      'album': albumController.text,
      'path': pathController.text,
    };
    await DatabaseHelper.instance.updateSong(song);

    // Regresar a la pantalla anterior y actualizar la lista
    Navigator.pop(context, true); // Pasar un valor true para indicar un cambio
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
