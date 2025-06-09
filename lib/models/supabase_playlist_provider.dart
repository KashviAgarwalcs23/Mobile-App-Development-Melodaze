import 'package:flutter/material.dart';
import 'package:untitled/services/playlist_service.dart';

class SupabasePlaylistProvider extends ChangeNotifier {
  final PlaylistService _playlistService = PlaylistService();
  List<Map<String, dynamic>> _playlists = [];
  Map<String, List<Map<String, dynamic>>> _playlistSongs = {};

  List<Map<String, dynamic>> get playlists => _playlists;
  List<Map<String, dynamic>> getSongs(String playlistId) => _playlistSongs[playlistId] ?? [];

  Future<void> fetchPlaylists() async {
    _playlists = await _playlistService.fetchPlaylists();
    notifyListeners();
  }

  Future<void> fetchSongsForPlaylist(String playlistId) async {
    _playlistSongs[playlistId] = await _playlistService.fetchSongsInPlaylist(playlistId);
    notifyListeners();
  }

  Future<void> addSongToPlaylist(String playlistId, String songId) async {
    print('Provider: Adding song to playlist: playlistId=$playlistId, songId=$songId');
    await _playlistService.addSongToPlaylist(playlistId, songId);
    await fetchSongsForPlaylist(playlistId);
  }

  Future<void> removeSongFromPlaylist(String playlistId, String playlistSongId) async {
    await _playlistService.removeSongFromPlaylist(playlistSongId);
    await fetchSongsForPlaylist(playlistId);
  }
}
