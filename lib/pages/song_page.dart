import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled/components/neu_box.dart';
import 'package:untitled/models/playlist_provider.dart';
import 'package:untitled/models/song.dart';
import 'package:untitled/utils/download_helper.dart';
import 'package:untitled/services/playlist_service.dart';
import 'package:untitled/models/supabase_playlist_provider.dart';

class SongPage extends StatelessWidget{
  const SongPage({super.key});

  //convert duration to min:sec
  String formatTime(Duration duration){
    String twoDigitSeconds=duration.inSeconds.remainder(60).toString().padLeft(2,'0');
    String formattedTime="${duration.inMinutes}: $twoDigitSeconds";

    return formattedTime;
  }

  @override
  Widget build(BuildContext context) {
    print('SongPage build method called');
    final allSongs = Provider.of<PlaylistProvider>(context).allSongs;
    return Consumer<PlaylistProvider>(
      builder: (context, value, child) {
        // get playlist
        final currentSong = value.allSongs[value.currentSongIndex ?? 0];

        // return scaffold UI
        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.surface,
          appBar: AppBar(
            title: const Text('P L A Y L I S T'),
            actions: [
              PopupMenuButton<String>(
                onSelected: (value) async {
                  print('PopupMenuButton onSelected: $value');
                  final playlistService = PlaylistService();
                  if (value == 'add') {
                    print('Opening Add to Playlist dialog');
                    final playlists = await playlistService.fetchPlaylists();
                    await showDialog(
                      context: context,
                      builder: (context) {
                        print('Building Add to Playlist dialog');
                        String? selectedPlaylistId;
                        TextEditingController newPlaylistController = TextEditingController();
                        bool showNewPlaylistField = false;
                        // Add a special entry for Liked Songs
                        final allPlaylists = [
                          {'id': 'favorites', 'name': 'Liked Songs'},
                          ...playlists
                        ];
                        return StatefulBuilder(
                          builder: (context, setState) {
                            print('Inside StatefulBuilder of Add to Playlist dialog');
                            return AlertDialog(
                              title: const Text('Add to Playlist'),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  DropdownButtonFormField<String>(
                                    value: selectedPlaylistId,
                                    items: allPlaylists.map<DropdownMenuItem<String>>((playlist) {
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
                                  TextButton(
                                    onPressed: () {
                                      setState(() {
                                        showNewPlaylistField = !showNewPlaylistField;
                                      });
                                    },
                                    child: Text(showNewPlaylistField ? 'Cancel' : 'Create New Playlist'),
                                  ),
                                  if (showNewPlaylistField)
                                    TextField(
                                      controller: newPlaylistController,
                                      decoration: InputDecoration(labelText: 'New Playlist Name'),
                                    ),
                                ],
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () async {
                                    print('Add button pressed');
                                    print('selectedPlaylistId: $selectedPlaylistId');
                                    print('showNewPlaylistField: $showNewPlaylistField');
                                    if (showNewPlaylistField && newPlaylistController.text.isNotEmpty) {
                                      // Create new playlist in Supabase
                                      final playlistService = PlaylistService();
                                      await playlistService.createPlaylist(newPlaylistController.text.trim());
                                      Navigator.pop(context);
                                    } else if (selectedPlaylistId == 'favorites') {
                                      // Add to local favorites
                                      Provider.of<PlaylistProvider>(context, listen: false).toggleFavorite(currentSong);
                                      Navigator.pop(context);
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('Added to Liked Songs!')),
                                      );
                                    } else if (selectedPlaylistId != null) {
                                      // Ensure the song exists in Supabase and get its ID
                                      final songMap = {
                                        'songName': currentSong.songName,
                                        'artistName': currentSong.artistName,
                                        'albumArtImagePath': currentSong.albumArtImagePath,
                                        'audioPath': currentSong.audioPath,
                                      };
                                      final songId = await playlistService.ensureSongInSupabase(songMap);

                                      // Use the provider to add the song and trigger real-time update
                                      await Provider.of<SupabasePlaylistProvider>(context, listen: false)
                                          .addSongToPlaylist(selectedPlaylistId!, songId);

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
                        );
                      },
                    );
                  } else if (value == 'download') {
                    final success = await downloadAssetToDownloads(
                      currentSong.audioPath,
                      '${currentSong.songName}.mp3',
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(success
                            ? 'Downloaded to Downloads folder!'
                            : 'Download failed or permission denied.'),
                      ),
                    );
                  }
                },
                itemBuilder: (context) {
                  print('Building PopupMenuButton items');
                  return [
                    const PopupMenuItem(
                      value: 'add',
                      child: Text('Add to Playlist'),
                    ),
                    const PopupMenuItem(
                      value: 'download',
                      child: Text('Download'),
                    ),
                  ];
                },
              ),
            ],
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(left: 25, right: 25, bottom: 25),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //album artwork
                  NeuBox(
                    child: Column(
                      children: [
                        //image
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(currentSong.albumArtImagePath),
                        ),

                        //song and artist name and icon
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Row(
                            children: [
                              //song and artist name
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    currentSong.songName,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                  Text(currentSong.artistName),
                                ],
                              ),

                              //heart icon
                              const Icon(
                                Icons.favorite,
                                color: Colors.red,
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 25),

                  //song duration process
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            //start time
                            Text(formatTime(value.currentDuration)),

                            //shuffle icon
                            GestureDetector(
                              onTap: value.toggleShuffle,
                              child: Icon(
                                Icons.shuffle,
                                color: value.isShuffle ? Colors.green : Colors.white,
                              ),
                            ),

                            //repeat icon
                            GestureDetector(
                              onTap: value.toggleRepeat,
                              child: Icon(
                                Icons.repeat,
                                color: value.isRepeat ? Colors.green : Colors.white,
                              ),
                            ),

                            //end time
                            Text(formatTime(value.totalDuration)),
                          ],
                        ),
                      ),

                      //song duration progress
                      SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          thumbShape:
                              const RoundSliderThumbShape(enabledThumbRadius: 0),
                        ),
                        child: Slider(
                          min: 0,
                          max: value.totalDuration.inSeconds.toDouble(),
                          value: value.currentDuration.inSeconds.toDouble(),
                          activeColor: Colors.green,
                          onChanged: (double double) {
                            //during when the user is sliding around
                          },
                          onChangeEnd: (double double){
                            // sliding has finished, go to that position in song duration
                            value.seek(Duration(seconds: double.toInt()));
                          },
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  //playback controls
                  Row(
                    children: [
                      //skip previous
                      Expanded(
                        child: GestureDetector(
                          onTap: value.playPreviousSong,
                          child: NeuBox(
                            child: Icon(Icons.skip_previous),
                          ),
                        ),
                      ),

                      const SizedBox(width: 20),

                      //play pause
                      Expanded(
                        flex: 2,
                        child: GestureDetector(
                          onTap: value.pauseOrResume,
                          child: NeuBox(
                            child: Icon(value.isPlaying ? Icons.pause: Icons.play_arrow),
                          ),
                        ),
                      ),

                      const SizedBox(width: 20),

                      //skip forward
                      Expanded(
                        child: GestureDetector(
                          onTap: value.playNextSong,
                          child: const NeuBox(
                            child: Icon(Icons.skip_next),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  // Add a button to add current song to queue (e.g., below playback controls)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {
                          value.addToQueue(currentSong);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Added to queue!')),
                          );
                        },
                        icon: Icon(Icons.queue_music),
                        label: Text('Add to Queue'),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton.icon(
                        onPressed: () {
                          value.clearQueue();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Queue cleared!')),
                          );
                        },
                        icon: Icon(Icons.clear_all),
                        label: Text('Clear Queue'),
                      ),
                    ],
                  ),

                  // Optionally, show the queue
                  if (value.playQueue.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Up Next:', style: TextStyle(color: Colors.white70)),
                          ...value.playQueue.map((song) => Text(
                            song.songName,
                            style: TextStyle(color: Colors.white54),
                          )),
                        ],
                      ),
                    ),

                ],
              ),
            ),
          ),
        );
      }
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