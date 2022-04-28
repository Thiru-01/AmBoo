import 'package:amboo/main.dart';
import 'package:spotify/spotify.dart';

Future<List<PlayHistory>> getRecent() async {
  SpotifyApi _spotify = SpotifyApi(credential);
  print(await _spotify.me.get());
  Me me = _spotify.me;

  Iterable<PlayHistory> data = await me.recentlyPlayed(limit: 10).then((value) {
    print("Fuccccccccccccccccccccccck");
    return value;
  });
  print(data);
  return data.toList();
}
