import 'package:base_datos_musica/edit_song_screen.dart';
import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'song_list_screen.dart';
import 'add_song_screen.dart';
import 'player_screen.dart';

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
        '/edit': (context) => const EditSongScreen(),
        '/player': (context) {
          final args =
              ModalRoute.of(context)!.settings.arguments
                  as Map<String, dynamic>;
          return PlayerScreen(
            title: args['title'],
            artist: args['artist'],
            album: args['album'],
            path: args['path'],
          );
        },
      },
    );
  }
}
