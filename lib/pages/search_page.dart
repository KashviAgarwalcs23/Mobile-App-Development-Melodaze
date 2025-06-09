import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled/models/playlist_provider.dart';
import 'package:untitled/models/song.dart';
import 'package:untitled/pages/song_page.dart';
import 'package:untitled/pages/recommendation_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  final List<String> categoryImages = [
    'assets/c1.jpg',
    'assets/c2.jpg',
    'assets/c3.jpg',
    'assets/c4.jpg',
    'assets/c5.jpg',
    'assets/c6.jpg',
    'assets/c7.jpg',
    'assets/c8.jpg',
    'assets/c9.jpg',
    'assets/c10.jpg',
    'assets/c11.jpg',
    'assets/c12.png',
  ];

  final List<String> categoryNames = [
    'Music', 'Pop', 'Hipop', 'Mood', 'Indie', 'Workout','Party','Love','Sleep','Rock','Anime','Ambient' // ...etc
  ];

  List<Song> _filteredSongs = [];
  List<dynamic> _onlineSongs = [];
  bool _isLoadingOnline = false;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void _handleCategoryTap(String category) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RecommendationPage(category: category),
      ),
    );
  }

  void _searchSongs(String query, List<Song> allSongs) {
    if (query.isEmpty) {
      setState(() {
        _filteredSongs = [];
      });
      return;
    }
    final lowerQuery = query.toLowerCase();
    setState(() {
      _filteredSongs = allSongs.where((song) =>
        song.songName.toLowerCase().contains(lowerQuery) ||
        song.artistName.toLowerCase().contains(lowerQuery)
      ).toList();
    });
  }

  Future<void> _searchOnlineSongs(String query) async {
    if (query.isEmpty) {
      setState(() {
        _onlineSongs = [];
      });
      return;
    }
    setState(() {
      _isLoadingOnline = true;
    });
    final formattedQuery = query.replaceAll('-', ' ').replaceAll('&', 'and');
    final url = 'https://itunes.apple.com/search?term=$formattedQuery&entity=song&limit=20';
    try {
      final httpResponse = await http.get(Uri.parse(url));
      if (httpResponse.statusCode == 200) {
        final data = json.decode(httpResponse.body);
        setState(() {
          _onlineSongs = data['results'];
        });
      } else {
        setState(() {
          _onlineSongs = [];
        });
      }
    } catch (e) {
      setState(() {
        _onlineSongs = [];
      });
    } finally {
      setState(() {
        _isLoadingOnline = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final allSongs = Provider.of<PlaylistProvider>(context).allSongs;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text('Search'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'My Songs'),
            Tab(text: 'Online'),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            TextField(
              controller: _searchController,
              style: const TextStyle(color: Colors.black),
              decoration: InputDecoration(
                hintText: 'Artists, songs, or podcasts',
                hintStyle: const TextStyle(color: Colors.black),
                prefixIcon: const Icon(Icons.search, color: Colors.black),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: Colors.black),
                        onPressed: () {
                          setState(() {
                            _searchController.clear();
                            _filteredSongs = [];
                            _onlineSongs = [];
                          });
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              onChanged: (value) {
                if (_tabController.index == 0) {
                  _searchSongs(value, allSongs);
                } else {
                  _searchOnlineSongs(value);
                }
              },
            ),
            const SizedBox(height: 20.0),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // My Songs Tab
                  _searchController.text.isNotEmpty
                      ? (_filteredSongs.isEmpty
                          ? const Center(
                              child: Text(
                                'No results found.\nTry another search!',
                                style: TextStyle(color: Colors.white70),
                                textAlign: TextAlign.center,
                              ),
                            )
                          : ListView.builder(
                              itemCount: _filteredSongs.length,
                              itemBuilder: (context, index) {
                                final song = _filteredSongs[index];
                                return ListTile(
                                  leading: song.albumArtImagePath.isNotEmpty
                                      ? Image.asset(song.albumArtImagePath, width: 40, height: 40, fit: BoxFit.cover)
                                      : const Icon(Icons.music_note),
                                  title: Text(song.songName),
                                  subtitle: Text(song.artistName),
                                  onTap: () {
                                    final provider = Provider.of<PlaylistProvider>(context, listen: false);
                                    final songIndex = provider.allSongs.indexWhere((s) => s.audioPath == song.audioPath);
                                    if (songIndex != -1) {
                                      provider.currentSongIndex = songIndex;
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => SongPage()),
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
                      : _buildBrowseAll(),
                  // Online Tab
                  _searchController.text.isNotEmpty
                      ? (_isLoadingOnline
                          ? const Center(child: CircularProgressIndicator())
                          : (_onlineSongs.isEmpty
                              ? const Center(
                                  child: Text(
                                    'No results found online.\nTry another search!',
                                    style: TextStyle(color: Colors.white70),
                                    textAlign: TextAlign.center,
                                  ),
                                )
                              : ListView.builder(
                                  itemCount: _onlineSongs.length,
                                  itemBuilder: (context, index) {
                                    final song = _onlineSongs[index];
                                    return ListTile(
                                      leading: song['artworkUrl100'] != null
                                          ? Image.network(song['artworkUrl100'], width: 40, height: 40, fit: BoxFit.cover)
                                          : const Icon(Icons.music_note),
                                      title: Text(song['trackName'] ?? ''),
                                      subtitle: Text(song['artistName'] ?? ''),
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => RecommendationPage(category: song['artistName'] ?? ''),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                )))
                      : _buildBrowseAll(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBrowseAll() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Browse all',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18.0,
            color: Colors.white70,
          ),
        ),
        const SizedBox(height: 10.0),
        Expanded(
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10.0,
              mainAxisSpacing: 10.0,
              childAspectRatio: 2 / 1, // Adjust aspect ratio to be wider
            ),
            itemCount: categoryImages.length,
            itemBuilder: (context, index) {
              final String categoryImage = categoryImages[index];
              return InkWell(
                onTap: () => _handleCategoryTap(categoryNames[index]),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    image: DecorationImage(
                      image: AssetImage(categoryImage),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}