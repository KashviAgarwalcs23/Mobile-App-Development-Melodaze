import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled/models/playlist_provider.dart';
import 'package:untitled/models/song.dart';
import 'package:untitled/pages/song_page.dart';
import 'package:untitled/pages/your_library.dart'; // Import YourLibraryPage
import 'package:untitled/pages/recommendation_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final PlaylistProvider playlistProvider;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    playlistProvider = Provider.of<PlaylistProvider>(context, listen: false);
  }

  void goToSong(int songIndex) {
    playlistProvider.currentSongIndex = songIndex;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SongPage(),
      ),
    );
  }

  void _showComingSoonSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('This will be implemented soon.'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _goToYourLibrary() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const YourLibraryPage()),
    );
  }

  void _showAddPlaylistDialog() {
    final TextEditingController controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Create New Playlist"),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: "Playlist Name"),
        ),
        actions: [
          TextButton(
            onPressed: () {
              playlistProvider.createPlaylist(controller.text.trim());
              Navigator.pop(context);
            },
            child: const Text("Create"),
          ),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(title: const Text("Welcome to Melodaze")),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Horizontal Scrolling Section
              SizedBox(
                height: 180.0, // Increased height to accommodate text
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  itemCount: 4, // Increased itemCount to include 'Add Playlist'
                  itemBuilder: (context, index) {
                    String imagePath;
                    String labelText;
                    VoidCallback onTapAction;
                    switch (index) {
                      case 0:
                        imagePath = 'assets/liked_songs_bg.jpg';
                        labelText = 'Liked Songs';
                        onTapAction = _goToYourLibrary;
                        break;
                      case 1:
                        imagePath = 'assets/add.jpg';
                        labelText = 'Add Playlist';
                        onTapAction = _showAddPlaylistDialog;// Implement add playlist logic later
                        break;
                      case 2:
                        imagePath = 'assets/top_songs_bg.jpg';
                        labelText = 'Top Songs';
                        onTapAction = () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RecommendationPage(category: 'Pop'),
                            ),
                          );
                        };
                        break;
                      case 3:
                        imagePath = 'assets/artist_mix_bg.jpeg';
                        labelText = 'Artist Mix';
                        onTapAction = () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RecommendationPage(category: 'Artist Mix'),
                            ),
                          );
                        };
                        break;
                      default:
                        imagePath = 'assets/placeholder_bg.jpg';
                        labelText = '';
                        onTapAction = () {};
                    }
                    return Padding(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: InkWell(
                        onTap: onTapAction,
                        child: SizedBox(
                          width: 150.0,
                          child: Column(
                            children: [
                              SizedBox(
                                width: 150.0,
                                height: 150.0,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: Image.asset(
                                    imagePath,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8.0),
                              Text(
                                labelText,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12.0,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20.0),

              // Trending Artists Section
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Trending Artists',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  ),
                ),
              ),
              const SizedBox(height: 8.0),
              SizedBox(
                height: 110.0,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  itemCount: 6,
                  itemBuilder: (context, index) {
                    String imagePath;
                    String artistName;
                    switch (index) {
                      case 0:
                        imagePath = 'assets/atif.jpg';
                        artistName = 'Atif Aslam';
                        break;
                      case 1:
                        imagePath = 'assets/shreya.jpg';
                        artistName = 'Shreya Ghoshal';
                        break;
                      case 2:
                        imagePath = 'assets/tailor.jpg';
                        artistName = 'Taylor Swift';
                        break;
                      case 3:
                        imagePath = 'assets/ed.jpg';
                        artistName = 'Ed Sheeran';
                        break;
                      case 4:
                        imagePath = 'assets/kuma.jpg';
                        artistName = 'Kuma Sagar';
                        break;
                      case 5:
                        imagePath = 'assets/yabesh.jpg';
                        artistName = 'Yabesh Thapa';
                        break;
                      default:
                        imagePath = 'assets/placeholder_artist.jpg';
                        artistName = 'Unknown';
                    }
                    return Padding(
                      padding: const EdgeInsets.only(right: 15.0),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RecommendationPage(category: artistName),
                            ),
                          );
                        },
                        child: Column(
                          children: [
                            Container(
                              width: 90.0,
                              height: 90.0,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.7),
                                  width: 0.8,
                                ),
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: AssetImage(imagePath),
                                ),
                              ),
                            ),
                            const SizedBox(height: 2.0),
                            Text(
                              artistName,
                              style: const TextStyle(fontSize: 9.0),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20.0),

              // Favourite Artists Section
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Favourite Artists',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  ),
                ),
              ),
              const SizedBox(height: 8.0),
              SizedBox(
                height: 110.0,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  itemCount: 1, // For now, just one favourite artist
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 15.0),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RecommendationPage(category: 'Taylor Swift'),
                            ),
                          );
                        },
                        child: Column(
                          children: [
                            Container(
                              width: 90.0,
                              height: 90.0,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.7),
                                  width: 0.8,
                                ),
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: AssetImage('assets/tailor.jpg'), // Reusing Taylor Swift's image
                                ),
                              ),
                            ),
                            const SizedBox(height: 2.0),
                            const Text(
                              'Taylor Swift',
                              style: TextStyle(fontSize: 9.0),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20.0),

              // Your existing playlist display
              Consumer<PlaylistProvider>(
                builder: (context, value, child) {
                  final List<Song> playlist = value.getPlaylistSongs("Liked Songs");
                  return ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: playlist.length,
                    itemBuilder: (context, index) {
                      final Song song = playlist[index];
                      return ListTile(
                        title: Text(song.songName),
                        subtitle: Text(song.artistName),
                        leading: Image.asset(song.albumArtImagePath),
                        onTap: () => goToSong(index),
                      );
                    },
                  );
                },
              ),

            ],
          ),
        ),
      ),
    );
  }
}