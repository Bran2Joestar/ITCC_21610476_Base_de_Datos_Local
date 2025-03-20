import 'dart:io';
import 'package:flutter/material.dart';

class PlayerScreen extends StatelessWidget {
  final String title;
  final String artist;
  final String album;
  final String path;
  final String photo; // Nueva propiedad para la foto
  final int likes; // Nueva propiedad para los likes

  const PlayerScreen({
    super.key,
    required this.title,
    required this.artist,
    required this.album,
    required this.path,
    required this.photo, // Añadir el parámetro
    required this.likes, // Añadir el parámetro
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reproduciendo')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Mostrar la imagen de la canción
              photo.isNotEmpty && File(photo).existsSync()
                  ? Image.file(File(photo), width: 100, height: 100)
                  : const Icon(
                    Icons.music_note,
                    size: 100,
                    color: Colors.white,
                  ),
              const SizedBox(height: 20),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                artist,
                style: const TextStyle(fontSize: 18, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 5),
              Text(
                album,
                style: const TextStyle(fontSize: 16, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              // Mostrar la cantidad de likes
              Text(
                'Likes: $likes',
                style: const TextStyle(fontSize: 16, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  // Aquí puedes implementar la lógica para reproducir la canción usando un paquete como audioplayers.
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 15,
                  ),
                  textStyle: const TextStyle(fontSize: 18),
                ),
                child: const Text('Reproducir'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
