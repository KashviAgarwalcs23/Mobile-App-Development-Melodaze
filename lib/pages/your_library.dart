import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled/models/playlist_provider.dart';
import 'package:untitled/models/song.dart';
import 'playlist_page.dart';
import 'package:untitled/services/playlist_service.dart';
import 'package:untitled/pages/song_page.dart';

class YourLibraryPage extends StatefulWidget {
  const YourLibraryPage({super.key});

  @override
  _YourLibraryPageState createState() => _YourLibraryPageState();
}

class _YourLibraryPageState extends State<YourLibraryPage> {
  List<Map<String, dynamic>> _playlists = [];

  @override
  void initState() {
    super.initState();
    _loadPlaylists();
  }

  void _loadPlaylists() async {
    final playlistService = PlaylistService();
    _playlists = await playlistService.fetchPlaylists();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PlaylistProvider>(context);
    final likedSongs = provider.getPlaylistSongs('Favorites');
    final allSongs = provider.allSongs;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text('Your Library'),
      ),
      body: ListView(
        children: [
          // Liked Songs
          ListTile(
            leading: Icon(Icons.favorite, color: Colors.red),
            title: Text('Liked Songs'),
            subtitle: Text('${likedSongs.length} songs'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PlaylistPage(
                    playlistId: 'Favorites',
                    playlistName: 'Liked Songs',
                    isEditable: false,
                  ),
                ),
              );
            },
          ),
          // All Songs
          ListTile(
            leading: Icon(Icons.music_note),
            title: Text('All Songs'),
            subtitle: Text('${allSongs.length} songs'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AllSongsPage(), // You can create this page or use a dialog
                ),
              );
            },
          ),
          // User Playlists from Supabase
          ..._playlists.map((playlist) => ListTile(
                leading: Icon(Icons.playlist_play),
                title: Text(playlist['name']),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PlaylistPage(
                        playlistId: playlist['id'],
                        playlistName: playlist['name'],
                        isEditable: true,
                      ),
                    ),
                  );
                },
              )),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreatePlaylistDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showCreatePlaylistDialog(BuildContext context) {
    final textController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('New Playlist'),
        content: TextField(
          controller: textController,
          decoration: const InputDecoration(
            hintText: 'Enter playlist name',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              if (textController.text.trim().isNotEmpty) {
                final playlistService = PlaylistService();
                await playlistService.createPlaylist(textController.text.trim());
                Navigator.pop(context);
                _loadPlaylists();
              }
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  void _showAddToPlaylistDialog(BuildContext context, Song song) async {
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
                    await _addStaticSongToPlaylist(song, selectedPlaylistId!);
                    Navigator.pop(context);
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

  Future<void> _addStaticSongToPlaylist(Song song, String playlistId) async {
    final playlistService = PlaylistService();
    // Convert Song object to map
    final songMap = {
      'songName': song.songName,
      'artistName': song.artistName,
      'albumArtImagePath': song.albumArtImagePath,
      'audioPath': song.audioPath,
    };
    // Ensure song exists in Supabase, get its id
    final songId = await playlistService.ensureSongInSupabase(songMap);
    // Add to playlist
    await playlistService.addSongToPlaylist(playlistId, songId);
  }
}

class AllSongsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PlaylistProvider>(context);
    final allSongs = provider.allSongs;

    return Scaffold(
      appBar: AppBar(title: Text('All Songs')),
      body: ListView.builder(
        itemCount: allSongs.length,
        itemBuilder: (context, index) {
          final song = allSongs[index];
          return ListTile(
            title: Text(song.songName),
            subtitle: Text(song.artistName),
            leading: Image.asset(song.albumArtImagePath),
            onTap: () {
              provider.currentSongIndex = index;
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SongPage()),
              );
            },
          );
        },
      ),
    );
  }
}