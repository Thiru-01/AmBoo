import 'dart:io';
import 'package:amboo/constant.dart';
import 'package:amboo/controller/datacontroller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spotify/spotify.dart';
import 'package:spotify_sdk/spotify_sdk.dart';
import 'pages/songpage.dart';

late SpotifyApiCredentials credential;
void main() {
  runApp(const MyApp());
  credential = SpotifyApiCredentials(
      "7c4ee6e4f46d455fa401338f7c9d12fb", 'd347907c8ecc45beacbf89321e08b900',
      scopes: ["user-read-recently-played"]);
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'AmBoo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          fontFamily: GoogleFonts.quicksand().fontFamily,
          primarySwatch: primaryColor,
          scaffoldBackgroundColor: Colors.white),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final formKey = GlobalKey<FormState>();
  DataController tokenController = Get.put(DataController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SafeArea(
          child: Column(
            children: [
              SizedBox(
                  height: MediaQuery.of(context).size.height * 0.09,
                  width: double.infinity,
                  child: Form(
                    key: formKey,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: TextFormField(
                            textInputAction: TextInputAction.go,
                            validator: (input) {
                              if (input!.isEmpty) {
                                return "Token can't be empty";
                              }
                              return null;
                            },
                            onFieldSubmitted: (_token) {
                              if (formKey.currentState!.validate()) {
                                formKey.currentState!.save();
                              }
                            },
                            onSaved: (_token) async {
                              try {
                                final result = await InternetAddress.lookup(
                                    "https://open.spotify.com/");
                                if (result.isNotEmpty &&
                                    result[0].rawAddress.isNotEmpty) {
                                  toNextPage(tokenController, _token, context);
                                }
                              } on SocketException catch (_) {
                                // print(e);
                                // Get.snackbar(
                                //     'Please check your internet connection', '',
                                //     snackPosition: SnackPosition.BOTTOM,
                                //     backgroundColor: Colors.white,
                                //     borderWidth: 2,
                                //     maxWidth:
                                //         MediaQuery.of(context).size.width * 0.9,
                                //     borderRadius: 5,
                                //     icon:
                                //         const Icon(FontAwesomeIcons.infoCircle),
                                //     borderColor: primaryColor);
                                toNextPage(tokenController, _token, context);
                              }
                            },
                            decoration: InputDecoration(
                                prefix: SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.05),
                                hintText: 'Enter the token',
                                contentPadding: const EdgeInsets.only(
                                  top: 0,
                                  bottom: 0,
                                  left: 0,
                                ),
                                suffixIcon: const Icon(FontAwesomeIcons.qrcode),
                                border: const OutlineInputBorder()),
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.03,
                        ),
                        TextButton(
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              formKey.currentState!.save();
                            }
                          },
                          style: TextButton.styleFrom(
                              side: const BorderSide(
                                  color: primaryColor, width: 2),
                              backgroundColor: Colors.white,
                              minimumSize: Size(
                                  MediaQuery.of(context).size.width * 0.1,
                                  MediaQuery.of(context).size.height * 0.053),
                              elevation: 0),
                          child: const Text(
                            'Connect',
                            style: TextStyle(color: primaryColor),
                          ),
                        )
                      ],
                    ),
                  )),
              SvgPicture.asset('assets/svg/1.svg')
            ],
          ),
        ),
      ),
    );
  }
}

Future<String> getAuthenticate() async {
  try {
    var authenticationToken = await SpotifySdk.getAuthenticationToken(
        clientId: "7c4ee6e4f46d455fa401338f7c9d12fb",
        redirectUrl: "ours.amboo:/",
        scope: 'app-remote-control, '
            'user-modify-playback-state, '
            'playlist-read-private, '
            'playlist-modify-public,user-read-currently-playing');
    return authenticationToken;
  } on PlatformException catch (e) {
    return Future.error('${e.code}: ${e.message}');
  } on MissingPluginException {
    return Future.error('not implemented');
  }
}

Future<bool> connectToRemoteSpotify(context) async {
  try {
    var result = await SpotifySdk.connectToSpotifyRemote(
        clientId: '7c4ee6e4f46d455fa401338f7c9d12fb',
        redirectUrl: 'ours.amboo:/');
    return result;
  } on PlatformException catch (e) {
    if (e.code == 'SpotifyRemoteServiceException') {
      Navigator.pop(context);
      Get.snackbar("Can't connect to spotify app",
          "please open the app and try again later",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.white,
          borderColor: primaryColor,
          borderRadius: 5,
          maxWidth: MediaQuery.of(context).size.width * 0.9,
          borderWidth: 2,
          icon: const Icon(FontAwesomeIcons.infoCircle));
      return Future.error('OpenError: Please run the application');
    }
    return Future.error('${e.code}: ${e.message}');
  } on MissingPluginException catch (e) {
    return Future.error('Message: ${e.message}');
  }
}

void toNextPage(tokenController, _token, context) async {
  SharedPreferences perfers = await SharedPreferences.getInstance();
  onLoading(context, 'Connecting...');
  if (perfers.containsKey('authToken')) {
    tokenController.getToken(_token ?? 'empty');
    bool connectionResult = await connectToRemoteSpotify(context);
    if (connectionResult) {
      navigator!.pop(context);
      Get.off(() => const SongPage());
    }
  } else {
    String authToken = await getAuthenticate();
    perfers.setString('authToken', authToken);
    toNextPage(tokenController, _token, context);
  }
}
