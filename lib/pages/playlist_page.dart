import 'package:flutter/material.dart';
import 'package:untitled/pages/song_page.dart';
import 'package:untitled/services/playlist_service.dart';
import 'package:untitled/models/song.dart';
import 'package:provider/provider.dart';
import 'package:untitled/models/playlist_provider.dart';
import 'package:untitled/models/supabase_playlist_provider.dart';

class PlaylistPage extends StatefulWidget {
  final String playlistId;
  final String playlistName;
  final bool isEditable;

  const PlaylistPage({
    super.key,
    required this.playlistId,
    required this.playlistName,
    this.isEditable = true,
  });

  @override
  State<PlaylistPage> createState() => _PlaylistPageState();
}

class _PlaylistPageState extends State<PlaylistPage> {
  final PlaylistService _playlistService = PlaylistService();
  List<Map<String, dynamic>> _songs = [];
  List<Map<String, dynamic>> _allSongs = [];
  String _playlistName = '';

  @override
  void initState() {
    super.initState();
    _playlistName = widget.playlistName;
    _loadSongs();
    _loadAllSongs();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final supabaseProvider = Provider.of<SupabasePlaylistProvider>(context, listen: false);
    supabaseProvider.fetchSongsForPlaylist(widget.playlistId);
  }

  void _loadSongs() async {
    _songs = await _playlistService.fetchSongsInPlaylist(widget.playlistId);
    setState(() {});
  }

  void _loadAllSongs() async {
    _allSongs = await _playlistService.fetchAllSongs();
    setState(() {});
  }

  void _addSong(String songId) async {
    await _playlistService.addSongToPlaylist(widget.playlistId, songId);
    _loadSongs();
  }

  void _removeSong(String playlistSongId) async {
    await _playlistService.removeSongFromPlaylist(playlistSongId);
    _loadSongs();
  }

  void _renamePlaylist(String newName) async {
    await _playlistService.renamePlaylist(widget.playlistId, newName);
    setState(() {
      _playlistName = newName;
    });
  }

  void _deletePlaylist() async {
    await _playlistService.deletePlaylist(widget.playlistId);
    Navigator.pop(context); // Go back to library
  }

  @override
  Widget build(BuildContext context) {
    final supabaseProvider = Provider.of<SupabasePlaylistProvider>(context);
    final songs = supabaseProvider.getSongs(widget.playlistId);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Text(_playlistName),
        actions: [
          if (widget.isEditable)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => _showEditOptions(context),
            ),
        ],
      ),
      body: widget.playlistId == 'Favorites'
          ? (songs == null || songs.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.music_off, size: 64),
                      const SizedBox(height: 16),
                      const Text('No songs in this playlist'),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: songs.length,
                  itemBuilder: (context, index) {
                    final song = songs![index];
                    return ListTile(
                      key: Key(song['audioPath']),
                      leading: song['albumArtImagePath'] != null
                          ? (song['albumArtImagePath'].startsWith('http')
                              ? Image.network(song['albumArtImagePath'])
                              : Image.asset(song['albumArtImagePath']))
                          : Icon(Icons.music_note),
                      title: Text(song['songName'] ?? song['name'] ?? ''),
                      subtitle: Text(song['artistName'] ?? song['artist'] ?? ''),
                      onTap: () {
                        final provider = Provider.of<PlaylistProvider>(context, listen: false);
                        final songIndex = provider.allSongs.indexWhere((s) => s.audioPath == song['audioPath']);

                        if (songIndex != -1) {
                          provider.currentSongIndex = songIndex;
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SongPage(),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Song not found in local assets.')),
                          );
                        }
                      },
                    );
                  },
                ))
          : _songs.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.music_off, size: 64),
                      const SizedBox(height: 16),
                      const Text('No songs in this playlist'),
                      if (widget.isEditable)
                        TextButton(
                          onPressed: () => _showAddSongsDialog(context),
                          child: const Text('Add Songs'),
                        ),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: _songs.length,
                  itemBuilder: (context, index) {
                    final playlistSong = _songs[index];
                    final songMap = playlistSong['songs'];
                    return ListTile(
                      key: Key(songMap['audioPath']),
                      leading: songMap['albumArtImagePath'] != null
                          ? (songMap['albumArtImagePath'].startsWith('http')
                              ? Image.network(songMap['albumArtImagePath'])
                              : Image.asset(songMap['albumArtImagePath']))
                          : Icon(Icons.music_note),
                      title: Text(songMap['songName'] ?? songMap['name'] ?? ''),
                      subtitle: Text(songMap['artistName'] ?? songMap['artist'] ?? ''),
                      trailing: widget.isEditable
                          ? IconButton(
                              icon: const Icon(Icons.remove),
                              onPressed: () => _removeSong(songMap['audioPath']),
                            )
                          : null,
                      onTap: () {
                        final provider = Provider.of<PlaylistProvider>(context, listen: false);
                        final songIndex = provider.allSongs.indexWhere((s) => s.audioPath == songMap['audioPath']);

                        if (songIndex != -1) {
                          provider.currentSongIndex = songIndex;
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SongPage(),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Song not found in local assets.')),
                          );
                        }
                      },
                      onLongPress: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (context) => Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ListTile(
                                leading: Icon(Icons.playlist_add),
                                title: Text('Add to Playlist'),
                                onTap: () async {
                                  // You can implement add to another playlist here
                                  Navigator.pop(context);
                                },
                              ),
                              ListTile(
                                leading: Icon(Icons.download),
                                title: Text('Download'),
                                onTap: () {
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Download started (not implemented)')),
                                  );
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
      floatingActionButton: widget.isEditable && widget.playlistId != 'Favorites'
          ? FloatingActionButton(
              onPressed: () => _showAddSongsDialog(context),
              child: const Icon(Icons.add),
            )
          : null,
    );
  }

  void _showEditOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.delete),
              title: const Text('Delete Playlist'),
              onTap: () async {
                Navigator.pop(context);
                _deletePlaylist();
              },
            ),
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Rename Playlist'),
              onTap: () {
                Navigator.pop(context);
                _showRenameDialog(context);
              },
            ),
          ],
        );
      },
    );
  }

  void _showRenameDialog(BuildContext context) {
    final textController = TextEditingController(text: _playlistName);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Rename Playlist'),
        content: TextField(
          controller: textController,
          decoration: const InputDecoration(
            hintText: 'Enter new name',
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
              final newName = textController.text.trim();
              if (newName.isNotEmpty && newName != _playlistName) {
                Navigator.pop(context);
                _renamePlaylist(newName);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showAddSongsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Songs'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _allSongs.length,
              itemBuilder: (context, index) {
                final song = _allSongs[index];
                final isInPlaylist = _songs.any((e) => e['songs']['id'] == song['id']);
                return CheckboxListTile(
                  value: isInPlaylist,
                  onChanged: (value) {
                    if (value == true) {
                      _addSong(song['id']);
                    } else {
                      // Find the playlist_song id for this song
                      final playlistSong = _songs.firstWhere(
                        (e) => e['songs']['id'] == song['id'],
                        orElse: () => {},
                      );
                      if (playlistSong.isNotEmpty) {
                        _removeSong(playlistSong['id']);
                      }
                    }
                  },
                  title: Text(song['songName'] ?? song['name'] ?? ''),
                  subtitle: Text(song['artistName'] ?? song['artist'] ?? ''),
                  secondary: song['albumArtImagePath'] != null
                      ? Image.asset(song['albumArtImagePath'], width: 40)
                      : null,
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Done'),
            ),
          ],
        );
      },
    );
  }
}

Song songFromMap(Map<String, dynamic> map) {
  return Song(
    songName: map['songName'] ?? map['name'] ?? '',
    artistName: map['artistName'] ?? map['artist'] ?? '',
    albumArtImagePath: map['albumArtImagePath'] ?? '',
    audioPath: map['audioPath'] ?? '',
  );
}