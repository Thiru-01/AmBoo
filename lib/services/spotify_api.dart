import 'package:spotify/spotify.dart';

class BaApi {
  static var cred = SpotifyApiCredentials(
      "7c4ee6e4f46d455fa401338f7c9d12fb", 'd347907c8ecc45beacbf89321e08b900',
      scopes: [
        'user-read-private',
        'user-read-email',
        'user-read-recently-played'
      ]);
  SpotifyApi _spotifyApi = SpotifyApi(cred);

  Future getSuggestion(patter) async {
    BundledPages data = await _spotifyApi.search.get(patter);
    print(await data.first());
    return data;
  }

  Future recentlyPlayed() async {
    var data = await _spotifyApi.me.recentlyPlayed();
    print(data);
  }
}
