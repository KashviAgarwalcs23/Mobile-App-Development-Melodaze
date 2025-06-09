import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:untitled/services/playlist_service.dart';

class DynamicSongPage extends StatelessWidget {
  final dynamic song;
  const DynamicSongPage({required this.song});

  Future<void> _addToPlaylist(BuildContext context) async {
    final playlistService = PlaylistService();
    final playlists = await playlistService.fetchPlaylists();
    String? selectedPlaylistId;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Add to Playlist'),
            content: DropdownButtonFormField<String>(
              value: selectedPlaylistId,
              items: playlists.map<DropdownMenuItem<String>>((playlist) {
                return DropdownMenuItem<String>(
                  value: playlist['id'],
                  child: Text(playlist['name']),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedPlaylistId = value;
                });
              },
              decoration: const InputDecoration(labelText: 'Select Playlist'),
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  if (selectedPlaylistId != null) {
                    // Prepare a map for the iTunes song
                    final songMap = {
                      'songName': song['trackName'],
                      'artistName': song['artistName'],
                      'albumArtImagePath': song['artworkUrl100'],
                      'audioPath': song['previewUrl'], // Use previewUrl as unique ID
                    };
                    // Ensure song exists in Supabase, get its id
                    final playlistService = PlaylistService();
                    final songId = await playlistService.ensureSongInSupabase(songMap);
                    await playlistService.addSongToPlaylist(selectedPlaylistId!, songId);
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Added to playlist!')),
                    );
                  }
                },
                child: const Text('Add'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(song['trackName'] ?? '')),
      body: Column(
        children: [
          Image.network(song['artworkUrl100']),
          Text(song['artistName'] ?? ''),
          // Add more details as you like
          ElevatedButton(
            onPressed: () async {
              final player = AudioPlayer();
              await player.play(UrlSource(song['previewUrl']));
            },
            child: Text('Play Preview'),
          ),
          ElevatedButton(
            onPressed: () => _addToPlaylist(context),
            child: Text('Add to Playlist'),
          ),
        ],
      ),
    );
  }
}
