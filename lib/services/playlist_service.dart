import 'package:supabase_flutter/supabase_flutter.dart';

class PlaylistService {
  final supabase = Supabase.instance.client;

  Future<void> createPlaylist(String name) async {
    final user = supabase.auth.currentUser;
    if (user == null) throw Exception('Not logged in');
    await supabase.from('playlists').insert({
      'user_id': user.id,
      'name': name,
    });
  }

  Future<List<Map<String, dynamic>>> fetchPlaylists() async {
    final user = supabase.auth.currentUser;
    if (user == null) throw Exception('Not logged in');
    final response = await supabase
        .from('playlists')
        .select()
        .eq('user_id', user.id)
        .order('created_at');
    return List<Map<String, dynamic>>.from(response);
  }

  Future<void> addSongToPlaylist(String playlistId, String songId) async {
    print('Adding song to playlist: playlistId=$playlistId, songId=$songId');
    final response = await supabase.from('playlist_songs').insert({
      'playlist_id': playlistId,
      'song_id': songId,
    }).select();
    print('Supabase addSongToPlaylist response: $response');
  }

  Future<List<Map<String, dynamic>>> fetchSongsInPlaylist(String playlistId) async {
    final response = await supabase
        .from('playlist_songs')
        .select('id, song_id, songs(*)')
        .eq('playlist_id', playlistId);
    return List<Map<String, dynamic>>.from(response);
  }

  Future<List<Map<String, dynamic>>> fetchAllSongs() async {
    final response = await supabase.from('songs').select();
    return List<Map<String, dynamic>>.from(response);
  }

  Future<void> removeSongFromPlaylist(String playlistSongId) async {
    await supabase.from('playlist_songs').delete().eq('id', playlistSongId);
  }

  Future<void> renamePlaylist(String playlistId, String newName) async {
    await supabase.from('playlists').update({'name': newName}).eq('id', playlistId);
  }

  Future<void> deletePlaylist(String playlistId) async {
    await supabase.from('playlists').delete().eq('id', playlistId);
  }

  Future<String> ensureSongInSupabase(Map<String, dynamic> song) async {
    print('Ensuring song in Supabase: $song');
    final response = await supabase
        .from('songs')
        .select('id')
        .eq('audioPath', song['audioPath'])
        .maybeSingle();
    print('Supabase ensureSongInSupabase select response: $response');

    if (response != null && response['id'] != null) {
      return response['id'];
    } else {
      final insertResponse = await supabase.from('songs').insert({
        'songName': song['songName'],
        'artistName': song['artistName'],
        'albumArtImagePath': song['albumArtImagePath'],
        'audioPath': song['audioPath'],
      }).select('id').single();
      print('Supabase ensureSongInSupabase insert response: $insertResponse');
      return insertResponse['id'];
    }
  }
}
