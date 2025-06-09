import 'dart:core';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:untitled/models/song.dart';

class PlaylistProvider extends ChangeNotifier {
  // Master list of all available songs
  final List<Song> _allSongs = [
    Song(
      songName: 'Counting Stars',
      artistName: 'OneRepublic',
      albumArtImagePath: 'assets/images/Counting stars.jpg',
      audioPath: 'audio/OneRepublic-Counting-Stars-(HipHopKit.com).mp3',
    ),
    Song(
      songName: 'No Lie',
      artistName: 'Dua Lipa',
      albumArtImagePath: 'assets/images/No lie.jpg',
      audioPath: 'audio/Sean-Paul-No-Lie-ft-Dua-Lipa-(HipHopKit.com).mp3',
    ),
    Song(
      songName: 'I Knew You Were Trouble',
      artistName: 'Taylor Swift',
      albumArtImagePath: 'assets/images/I knew you were trouble.jpg',
      audioPath: 'audio/Taylor Swift - I Knew You Were Trouble..mp3',
    ),
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
    Song(
      songName: 'Yadaan Teriyaan',
      artistName: 'Rahat Fateh Ali Khan; ',
      albumArtImagePath: 'assets/images/Hero.jpg',
      audioPath: 'audio/02 - Yadaan Teriyaan (Version 1) - DownloadMing.SE.mp3',
    ),
    Song(
      songName: 'Chichora Piya',
      artistName: 'Himesh Reshammiya & Shalmali Kholgade; ',
      albumArtImagePath: 'assets/images/Action Jackson.jpg',
      audioPath: 'audio/03 - Chichora Piya - DownloadMing.SE.mp3',
    ),
    Song(
      songName: 'Dance Ke Legend',
      artistName: 'Meet Bros, Bhoomi Trivedi, Sunaina Singh; ',
      albumArtImagePath: 'assets/images/Hero.jpg',
      audioPath: 'audio/03 - Dance Ke Legend - DownloadMing.SE.mp3',
    ),
    Song(
      songName: 'Long drive',
      artistName: 'Mika Singh',
      albumArtImagePath: 'assets/images/Khiladi.jpg',
      audioPath: 'audio/03 - Long Drive- DownloadMing.SE.mp3',
    ),
    Song(
      songName: 'Dhoom dhaam',
      artistName: 'Ankit Tiwari & Palak Muchhal ',
      albumArtImagePath: 'assets/images/Action Jackson.jpg',
      audioPath: 'audio/04 - Dhoom Dhaam - DownloadMing.SE.mp3',
    ),
    Song(
      songName: 'Khoya Khoya',
      artistName: 'Mohit Chauhan, Priya Panchal, Arpita Chakraborty, Tanishka Sanghvi',
      albumArtImagePath: 'assets/images/Hero.jpg',
      audioPath: 'audio/04 - Khoya Khoya - DownloadMing.SE.mp3',
    ),
    Song(
      songName: 'Gangster Baby',
      artistName: 'Neeraj Shridhar & Neeti Mohan',
      albumArtImagePath: 'assets/images/Action Jackson.jpg',
      audioPath: 'audio/05 - Gangster Baby - DownloadMing.SE.mp3',
    ),
    Song(
      songName: 'Hookah Bar',
      artistName: 'Himesh Reshammiya, Vineet Singh & Aman Trikha',
      albumArtImagePath: 'assets/images/Khiladi.jpg',
      audioPath: 'audio/05 - Hookah Bar- DownloadMing.SE.mp3',
    ),
    Song(
      songName: 'O Khuda',
      artistName: 'Amaal Mallik, Palak Muchchal',
      albumArtImagePath: 'assets/images/Hero.jpg',
      audioPath: 'audio/05 - O Khuda - DownloadMing.SE.mp3',
    ),
    Song(
      songName: 'Jab We Met',
      artistName: 'Benny Dayal, Shalmali Kholgade, Divya Kumar, Jigar Saraiya',
      albumArtImagePath: 'assets/images/Hero.jpg',
      audioPath: 'audio/06 - Jab We Met - DownloadMing.SE.mp3',
    ),
    Song(
      songName: 'Keeda (Remix)',
      artistName: 'Himmesh Reshamia and Neeti Mohan',
      albumArtImagePath: 'assets/images/Action Jackson.jpg',
      audioPath: 'audio/06 - Keeda (Remix) - DownloadMing.SE.mp3',
    ),
    Song(
      songName: 'Khiladi (Title Track)',
      artistName: 'Vineet Singh, Aman Trikha, Yashraj Kapil, Alam Gir Khan, Rajdeep Chatterjee',
      albumArtImagePath: 'assets/images/Khiladi.jpg',
      audioPath: 'audio/06 - Khiladi (Title Track)- DownloadMing.SE.mp3',
    ),
    Song(
      songName: 'Punjabi Mast (Remix)',
      artistName: ' Himesh, Ankit Tiwari, Arya Acharya, Alam Gir Khan, Vineet Singh & Neeti Mohan',
      albumArtImagePath: 'assets/images/Action Jackson.jpg',
      audioPath: 'audio/07 - Punjabi Mast (Remix) - DownloadMing.SE.mp3',
    ),
    Song(
      songName: 'Tu Hoor Pari',
      artistName: 'Javed Ali, Shreya Ghoshal, Chandrakala Singh & Harshdeep Kaur',
      albumArtImagePath: 'assets/images/Khiladi.jpg',
      audioPath: 'audio/07 - Tu Hoor Pari- DownloadMing.SE.mp3',
    ),
    Song(
      songName: 'Yadaan Teriyaan (Version 2)',
      artistName: 'Dev Negi, Shipra Goyal',
      albumArtImagePath: 'assets/images/Hero.jpg',
      audioPath: 'audio/07 - Yadaan Teriyaan (Version 2) - DownloadMing.SE.mp3',
    ),
    Song(
      songName: 'Chichora Piya (Remix)',
      artistName: 'Himesh Reshammiya & Shalmali Kholgade',
      albumArtImagePath: 'assets/images/Action Jackson.jpg',
      audioPath: 'audio/08 - Chichora Piya (Remix) - DownloadMing.SE.mp3',
    ),
    Song(
      songName: 'Main Hoon Hero Tera (Armaan Malik ver.)',
      artistName: 'Armaan Malik',
      albumArtImagePath: 'assets/images/Hero.jpg',
      audioPath: 'audio/08 - Main Hoon Hero Tera (Armaan Malik Version) - DownloadMing.SE.mp3',
    ),
    Song(
      songName: 'Hookah Bar (Remix)',
      artistName: 'Himesh Reshammiya, Vineet Singh & Aman Trikha',
      albumArtImagePath: 'assets/images/Khiladi.jpg',
      audioPath: 'audio/09 - Hookah Bar (Remix)- DownloadMing.SE.mp3',
    ),
    Song(
      songName: 'Keeda (Reprise)',
      artistName: 'Himmesh Reshamia and Neeti Mohan',
      albumArtImagePath: 'assets/images/Action Jackson.jpg',
      audioPath: 'audio/09 - Keeda (Reprise) - DownloadMing.SE.mp3',
    ),
    Song(
      songName: 'Long Drive (Bhangra remix)',
      artistName: 'Mika Singh',
      albumArtImagePath: 'assets/images/Khiladi.jpg',
      audioPath: 'audio/10 - Long Drive (Bhangra Mix)- DownloadMing.SE.mp3',
    ),
    Song(
      songName: 'Har Har Gange',
      artistName: 'Arijit Singh',
      albumArtImagePath: 'assets/images/Batti Gul Meter jha.jpg',
      audioPath: 'audio/320kbps_BGMC 2018 - Har Har Gange.mp3',
    ),
    Song(
      songName: 'Hud Hud Dabangg',
      artistName: 'Sukhwinder Singh, Wajid Ali',
      albumArtImagePath: 'assets/images/Dabang.jpg',
      audioPath: 'audio/320kbps_Dabangg 2010 - Hud Hud Dabangg.mp3',
    ),
    Song(
      songName: 'Jhuk Na Paunga',
      artistName: 'Papon',
      albumArtImagePath: 'assets/images/Raid.jpg',
      audioPath: 'audio/320kbps_Raid 2018 - Jhuk Na Paunga.mp3',
    ),
    Song(
      songName: 'Bass Gira De Raja',
      artistName: 'Shashwat Sachdev',
      albumArtImagePath: 'assets/images/Veeri di wedding.jpg',
      audioPath: 'audio/320kbps_VDW 2018 - Bass Gira De Raja.mp3',
    ),
    Song(
      songName: 'Pappi Le Loon',
      artistName: 'Sunidhi Chauhan, Shashwat Sachdev',
      albumArtImagePath: 'assets/images/Veeri di wedding.jpg',
      audioPath: 'audio/320kbps_VDW 2018 - Pappi Le Loon.mp3',
    ),
    Song(
      songName: 'Tareefan',
      artistName: 'Badshah',
      albumArtImagePath: 'assets/images/Veeri di wedding.jpg',
      audioPath: 'audio/320kbps_VDW 2018 - Tareefan.mp3',
    ),
    Song(
      songName: 'Ala Barfi (Kaju Barfi)',
      artistName: 'Pritam',
      albumArtImagePath: 'assets/images/Barfi.jpg',
      audioPath: 'audio/Ala Barfi (Kaju Barfi).mp3',
    ),
    Song(
      songName: 'Allah Waariyan Yaariyan',
      artistName: 'Shafqat Amanat Ali',
      albumArtImagePath: 'assets/images/yaariyan.jpg',
      audioPath: 'audio/Allah Waariyan Yaariyan 320 Kbps.mp3',
    ),
    Song(
      songName: 'Ban Ja Rani Tumhari Sulu',
      artistName: 'Guru Randhawa',
      albumArtImagePath: 'assets/images/Tumhari-Sulu-2.jpg',
      audioPath: 'audio/Ban Ja Rani Tumhari Sulu 320 Kbps.mp3',
    ),
    Song(
      songName: 'Barfi Mohit Chauhan',
      artistName: 'Mohit Chauhan',
      albumArtImagePath: 'assets/images/Barfi.jpg',
      audioPath: 'audio/Barfi Mohit Chauhan 320 Kbps.mp3',
    ),
    Song(
      songName: 'Bhare Bazaar Namaste England',
      artistName: 'Payal Dev, Badshah, Vishal Dadlani, Rishi Rich',
      albumArtImagePath: 'assets/images/Namaste england.jpg',
      audioPath: 'audio/Bhare Bazaar Namaste England 320 Kbps.mp3',
    ),
    Song(
      songName: 'Calm Down',
      artistName: 'Rema, Selena Gomez',
      albumArtImagePath: 'assets/images/calm down.jpg',
      audioPath: 'audio/Calm Down-(SongsPK).mp3',
    ),
    Song(
      songName: 'Chaar Shanivaar All is well',
      artistName: 'Vishal Dadlani, Armaan Malik, Badshah, Amaal Mallik',
      albumArtImagePath: 'assets/images/all is well.jpg',
      audioPath: 'audio/Chaar Shanivaar All Is Well 320 Kbps.mp3',
    ),
    Song(
      songName: 'Chori Kiya Re Jiya (Male) - Dabangg',
      artistName: 'Sajid-Wajid, Sonu Nigam, Shreya Ghoshal',
      albumArtImagePath: 'assets/images/Dabang.jpg',
      audioPath: 'audio/Chori Kiya Re Jiya (Male) - Dabangg 320 Kbps.mp3',
    ),
    Song(
      songName: 'Dekha Ek Khwab',
      artistName: 'Lata Mangeshkar, Kishore Kumar; ',
      albumArtImagePath: 'assets/images/silsila.jpg',
      audioPath: 'audio/Dekha Ek Khwab Ii - Silsila 320 Kbps.mp3',
    ),
    Song(
      songName: 'Dil Karta Hai Tere Pas Aaoon ',
      artistName: 'Tushar Bhatia, Mangal Singh',
      albumArtImagePath: 'assets/images/Andaz apna apna.jpg',
      audioPath: 'audio/Dil Karta Hai Tere Pas Aaoon - Andaz Apna Apna 320 Kbps.mp3',
    ),
    Song(
      songName: 'Dua Karo',
      artistName: 'Arijit Singh, Bohemia, Sachin-Jigar; ',
      albumArtImagePath: 'assets/images/street dancer.jpg',
      audioPath: 'audio/Dua Karo - Street Dancer 3D 320 Kbps.mp3',
    ),
    Song(
      songName: 'Feel The Rhythm ',
      artistName: 'Pranaay',
      albumArtImagePath: 'assets/images/Munna Michael.jpg',
      audioPath: 'audio/Feel The Rhythm Munna Michael 320 Kbps.mp3',
    ),
    Song(
      songName: 'Gold Tamba',
      artistName: 'Nakash Aziz',
      albumArtImagePath: 'assets/images/Batti Gul Meter jha.jpg',
      audioPath: 'audio/Gold Tamba Batti Gul Meter Chalu 320 Kbps.mp3',
    ),
    Song(
      songName: 'Hawai Hawai',
      artistName: 'Kavita Krishnamurti Subramaniam; ',
      albumArtImagePath: 'assets/images/Mr india.jpg',
      audioPath: 'audio/Hawa Hawai Mr India 320 Kbps.mp3',
    ),
    Song(
      songName: 'I love you',
      artistName: 'Pritam, Clinton Cerejo, Ash King; ',
      albumArtImagePath: 'assets/images/Bodyguard.jpg',
      audioPath: 'audio/I Love You - Bodyguard 320 Kbps.mp3',
    ),
    Song(
      songName: 'Jungle Hai',
      artistName: 'Kumar Sanu, Hema Sardesai; ',
      albumArtImagePath: 'assets/images/biwi no 1.jpg',
      audioPath: 'audio/Jungle Hai - Biwi No. 1 320 Kbps.mp3',
    ),
    Song(
      songName: 'Kate Nahin Kat Te',
      artistName: 'Kishore Kumar, Alisha Chinai; ',
      albumArtImagePath: 'assets/images/Mr india.jpg',
      audioPath: 'Kate Nahin Kat Te Mr India 320 Kbps.mp3',
    ),
    Song(
      songName: 'Main Tera Boyfriend',
      artistName: 'Arijit Singh, Neha Kakkar; ',
      albumArtImagePath: 'assets/images/Raabta.jpg',
      audioPath: 'audio/Main Tera Boyfriend - Raabta 320 Kbps.mp3',
    ),
    Song(
      songName: 'Lamborghini Chalai Janiyo',
      artistName: 'Ragini',
      albumArtImagePath: 'assets/images/Action Jackson.jpg',
      audioPath: 'audio/Lamborghini Chalai Janiyo.mp3',
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