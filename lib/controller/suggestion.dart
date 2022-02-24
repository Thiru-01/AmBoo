import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

getSuggestion(pattern) async {
  SharedPreferences prefer = await SharedPreferences.getInstance();
  http.Response data = await getAccessToken();
  print("thiruuuuuuuuuuuuuuuuuuuu:${data.body}");
  String baseUrl =
      'https://api.spotify.com/v1/$pattern?type=album&include_external=audio';
  Map<String, String> header = {
    'Authorization': '7c4ee6e4f46d455fa401338f7c9d12fb',
    'Content-Type': 'application/json'
  };
  http.Response result = await http.get(Uri.parse(baseUrl), headers: header);
  print(result.body);
}

Future<http.Response> getAccessToken() async {
  String baseUrl = 'https://accounts.spotify.com/api/token';
  Map<String, String> header = {
    "grant_type": "authorization_code",
    "redirect_uri": 'amboo://callback',
    "client_secret": 'f1c5d2edc8204deda6f30d516b923931',
    "client_id": '7c4ee6e4f46d455fa401338f7c9d12fb',
  };
  http.Response result = await http.post(Uri.parse(baseUrl), headers: header);
  return result;
}
