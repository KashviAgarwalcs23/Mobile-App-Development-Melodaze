import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:audioplayers/audioplayers.dart';
import 'package:untitled/pages/dynamic_song_page.dart';

class RecommendationPage extends StatefulWidget {
  final String category;
  const RecommendationPage({required this.category});

  @override
  _RecommendationPageState createState() => _RecommendationPageState();
}

class _RecommendationPageState extends State<RecommendationPage> {
  late Future<List<dynamic>> _songsFuture;

  @override
  void initState() {
    super.initState();
    _songsFuture = fetchSongs(widget.category);
  }

  Future<List<dynamic>> fetchSongs(String query) async {
    String formattedQuery = query.replaceAll('-', ' ').replaceAll('&', 'and');
    final url = 'https://itunes.apple.com/search?term=$formattedQuery&entity=song&limit=20';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['results'];
    } else {
      throw Exception('Failed to load songs');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Recommendations for ${widget.category}')),
      body: FutureBuilder<List<dynamic>>(
        future: _songsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No songs found.'));
          }
          final songs = snapshot.data!;
          return ListView.builder(
            itemCount: songs.length,
            itemBuilder: (context, index) {
              final song = songs[index];
              return ListTile(
                leading: song['artworkUrl100'] != null
                    ? Image.network(song['artworkUrl100'], width: 50, height: 50)
                    : Icon(Icons.music_note),
                title: Text(song['trackName'] ?? ''),
                subtitle: Text(song['artistName'] ?? ''),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DynamicSongPage(song: song),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
