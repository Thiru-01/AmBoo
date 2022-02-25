import 'package:amboo/controller/datacontroller.dart';
import 'package:amboo/model/spotifymodel.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:spotify/spotify.dart';

Future<List<String>> getSuggestion(String pattern) async {
  DataController controller = Get.find(tag: 'dataController');
  final credential = SpotifyApiCredentials(
      "7c4ee6e4f46d455fa401338f7c9d12fb", '52a768eb4f5f4614bf60fca3b1aa5b05');
  SpotifyApi spotifyApi = SpotifyApi(
    credential,
  );
  SpotifyApiCredentials accessTokenSet = await spotifyApi.getCredentials();

  List<String> name = [];
  if (pattern.isNotEmpty) {
    String baseUrl =
        'https://api.spotify.com/v1/search?q=$pattern&type=track&limit=10';
    Map<String, String> header = {
      'Authorization': 'Bearer ${accessTokenSet.accessToken}',
      'Content-Type': 'application/json'
    };
    http.Response result = await http.get(Uri.parse(baseUrl), headers: header);
    SpotifyModel model = spotifyModelFromJson(result.body);
    List<Item?> items = model.tracks.items;
    for (int i = 0; i < items.length; i++) {
      name.add(items[i]!.name);
      controller.setContent(items[i]!.name, model.tracks.items[i]);
    }
  }

  return name;
}
