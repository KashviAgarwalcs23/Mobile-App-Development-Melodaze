import 'dart:core';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:untitled/models/song.dart';

class PlaylistProvider extends ChangeNotifier {
  // Master list of all available songs
  final List<Song> _allSongs = [
    

    Song(
  songName: 'Keeda',
  artistName: 'Himmesh Reshamia and Neeti Mohan',
  albumArtImagePath: 'assets/images/Action Jackson.jpg',
  audioPath: 'audio/01 - Keeda - DownloadMing.SE.mp3',
),
Song(
      songName: 'Lonely',
      artistName: 'Himmesh Reshamia, Yo Yo Honey Singh',
      albumArtImagePath: 'assets/images/Hero.jpg',
      audioPath: 'audio/01 - Lonely- DownloadMing.SE.mp3',
    ),
    Song(
      songName: 'Balma',
      artistName: 'Shriram & Shreya Goshal',
      albumArtImagePath: 'assets/images/Khiladi.jpg',
      audioPath: 'audio/02 - Balma- DownloadMing.SE.mp3',
    ),
    Song(
      songName: 'Punjabi Mast',
      artistName: 'Himesh, Ankit Tiwari, Neeti Mohan, Arya Acharya, Alam Gir Khan & Vineet Singh; ',
      albumArtImagePath: 'assets/images/Action Jackson.jpg',
      audioPath: 'audio/02 - Punjabi Mast - DownloadMing.SE.mp3',
    ),
    // Add more songs as needed
  ];

  // Dynamic playlists storage
  final Map<String, List<Song>> _playlists = {
    'Favorites': [], // Special playlist for favorites
    'Recently Played': [], // Special playlist for history
    // User-created playlists will be added here
  };

  // Current playback state
  int? _currentSongIndex;
  final AudioPlayer _audioPlayer = AudioPlayer();
  Duration _currentDuration = Duration.zero;
  Duration _totalDuration = Duration.zero;
  bool _isPlaying = false;

  // Shuffle, repeat, and queue state
  bool _isShuffle = false;
  bool _isRepeat = false;
  final List<Song> _playQueue = [];

  PlaylistProvider() {
    listenToDuration();
  }

  /* -------------------------------
     P L A Y L I S T   M A N A G E M E N T
  ------------------------------- */

  // Create a new playlist
  void createPlaylist(String name) {
    if (!_playlists.containsKey(name)) {
      _playlists[name] = [];
      notifyListeners();
    }
  }

  // Delete a playlist
  void deletePlaylist(String name) {
    if (_playlists.containsKey(name) && name != 'Favorites' && name != 'Recently Played') {
      _playlists.remove(name);
      notifyListeners();
    }
  }

  // Add song to playlist
  void addToPlaylist(String playlistName, Song song) {
    if (_playlists.containsKey(playlistName)) {
      if (!_playlists[playlistName]!.contains(song)) {
        _playlists[playlistName]!.add(song);
        notifyListeners();
      }
    }
  }

  // Remove song from playlist
  void removeFromPlaylist(String playlistName, Song song) {
    if (_playlists.containsKey(playlistName)) {
      _playlists[playlistName]!.remove(song);
      notifyListeners();
    }
  }

  // Add to favorites
  void toggleFavorite(Song song) {
    if (_playlists['Favorites']!.contains(song)) {
      _playlists['Favorites']!.remove(song);
    } else {
      _playlists['Favorites']!.add(song);
    }
    notifyListeners();
  }

  /* -------------------------------
     P L A Y B A C K   C O N T R O L S
  ------------------------------- */

  //play the song
  void play() async {
    if (_currentSongIndex != null && _currentSongIndex! < _allSongs.length) {
      final String path = _allSongs[_currentSongIndex!].audioPath;
      await _audioPlayer.stop(); //stop current song
      await _audioPlayer.play(AssetSource(path)); //play new song
      _isPlaying = true;

      // Add to recently played
      if (!_playlists['Recently Played']!.contains(_allSongs[_currentSongIndex!])) {
        _playlists['Recently Played']!.insert(0, _allSongs[_currentSongIndex!]);
        if (_playlists['Recently Played']!.length > 10) {
          _playlists['Recently Played']!.removeLast();
        }
      }

      notifyListeners();
    }
  }

  //pause the current song
  void pause() async {
    await _audioPlayer.pause();
    _isPlaying = false;
    notifyListeners();
  }

  //resume playing
  void resume() async {
    await _audioPlayer.resume();
    _isPlaying = true;
    notifyListeners();
  }

  //pause or resume
  void pauseOrResume() async {
    if (_isPlaying) {
      pause();
    } else {
      resume();
    }
  }

  //seek to a specific position in the current song
  void seek(Duration position) async {
    await _audioPlayer.seek(position);
  }

  //play next song
  void playNextSong() {
    if (_playQueue.isNotEmpty) {
      // Play next song in queue
      final nextSong = _playQueue.removeAt(0);
      final nextIndex = _allSongs.indexWhere((s) => s.audioPath == nextSong.audioPath);
      if (nextIndex != -1) {
        currentSongIndex = nextIndex;
      }
      notifyListeners();
      return;
    }
    if (_isRepeat) {
      // Replay current song
      play();
      notifyListeners();
      return;
    }
    if (_isShuffle) {
      if (_allSongs.length > 1) {
        int nextIndex;
        do {
          nextIndex = (List.generate(_allSongs.length, (i) => i)..shuffle()).first;
        } while (nextIndex == _currentSongIndex);
        currentSongIndex = nextIndex;
      }
      notifyListeners();
      return;
    }
    // Default: play next in order
    if (_currentSongIndex != null) {
      if (_currentSongIndex! < _allSongs.length - 1) {
        currentSongIndex = _currentSongIndex! + 1;
      } else {
        currentSongIndex = 0;
      }
    }
    notifyListeners();
  }

  //play previous song
  void playPreviousSong() async {
    // if more than 2 sec passed, restart the song
    if (_currentDuration.inSeconds > 2) {
      seek(Duration.zero);
    } else {
      //if it is within first 2 sec of the song, go to previous song
      if (_currentSongIndex! > 0) {
        currentSongIndex = _currentSongIndex! - 1;
      } else {
        //if it is first song, loop back to the last song
        currentSongIndex = _allSongs.length - 1;
      }
    }
  }

  //listen to duration
  void listenToDuration() {
    //listen for total duration
    _audioPlayer.onDurationChanged.listen((newDuration) {
      _totalDuration = newDuration;
      notifyListeners();
    });

    //listen for current duration
    _audioPlayer.onPositionChanged.listen((newPosition) {
      _currentDuration = newPosition;
      notifyListeners();
    });

    //listen for song completion
    _audioPlayer.onPlayerComplete.listen((event) {
      playNextSong();
    });
  }

  void updatePlaylistOrder(String playlistName, List<Song> newOrder) {
    _playlists[playlistName] = List<Song>.from(newOrder);
    notifyListeners();
  }

  /*
    G E T T E R S
  */
  List<Song> get allSongs => _allSongs;
  List<String> get playlistNames => _playlists.keys.toList();
  List<Song> getPlaylistSongs(String name) => _playlists[name] ?? [];
  bool isFavorite(Song song) => _playlists['Favorites']!.contains(song);
  int? get currentSongIndex => _currentSongIndex;
  bool get isPlaying => _isPlaying;
  Duration get currentDuration => _currentDuration;
  Duration get totalDuration => _totalDuration;
  bool get isShuffle => _isShuffle;
  bool get isRepeat => _isRepeat;
  List<Song> get playQueue => List.unmodifiable(_playQueue);

  /*
    S E T T E R S
  */
  set currentSongIndex(int? newIndex) {
    //update current song index
    _currentSongIndex = newIndex;

    if (newIndex != null) {
      play(); //play song at new index
    }

    //update UI
    notifyListeners();
  }

  void toggleShuffle() {
    _isShuffle = !_isShuffle;
    notifyListeners();
  }

  void toggleRepeat() {
    _isRepeat = !_isRepeat;
    notifyListeners();
  }

  void addToQueue(Song song) {
    _playQueue.add(song);
    notifyListeners();
  }

  void clearQueue() {
    _playQueue.clear();
    notifyListeners();
  }
}
