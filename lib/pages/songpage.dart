import 'package:amboo/constant.dart';
import 'package:amboo/controller/suggestion.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spotify_sdk/models/connection_status.dart';
import 'package:spotify_sdk/spotify_sdk.dart';

class SongPage extends StatefulWidget {
  const SongPage({Key? key}) : super(key: key);

  @override
  State<SongPage> createState() => _SongPageState();
}

class _SongPageState extends State<SongPage> {
  @override
  Widget build(BuildContext context) {
    double scaleFactor = MediaQuery.of(context).textScaleFactor;
    return Scaffold(
      appBar: appBar(scaleFactor),
      body: SafeArea(
        child: StreamBuilder<ConnectionStatus>(
            stream: SpotifySdk.subscribeConnectionStatus(),
            builder: (context, snapshot) {
              return SingleChildScrollView(
                child: Padding(
                  padding:
                      EdgeInsets.all(MediaQuery.of(context).size.width * 0.04),
                  child: Column(
                    children: [
                      TextButton(
                          onPressed: () async {
                            await getSuggestion('oru');
                          },
                          child: const Text('Go'))
                      // TypeAheadField(
                      //   onSuggestionSelected: (suggestion) {
                      //     print(suggestion);
                      //   },
                      //   suggestionsCallback: (pattern) {
                      //     return getSuggestion(pattern);
                      //   },
                      //   itemBuilder: ((context, itemData) {
                      //     return Container();
                      //   }),
                      //   textFieldConfiguration: TextFieldConfiguration(
                      //       decoration: InputDecoration(
                      //           prefix: SizedBox(
                      //               width: MediaQuery.of(context).size.width *
                      //                   0.05),
                      //           hintText: 'Search',
                      //           contentPadding: const EdgeInsets.only(
                      //             top: 0,
                      //             bottom: 0,
                      //             left: 0,
                      //           ),
                      //           suffixIcon:
                      //               const Icon(FontAwesomeIcons.search),
                      //           border: const OutlineInputBorder())),
                      // ),
                      ,
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.05,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: RichText(
                            text: TextSpan(
                                text: "Hey, ",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily:
                                        GoogleFonts.quicksand().fontFamily,
                                    fontSize: scaleFactor * 22,
                                    fontWeight: FontWeight.w100),
                                children: [
                              TextSpan(
                                  text: "Good Morning !",
                                  style: TextStyle(
                                      color: primaryColor,
                                      fontSize: scaleFactor * 22,
                                      fontWeight: FontWeight.bold))
                            ])),
                      )
                    ],
                  ),
                ),
              );
            }),
      ),
    );
  }

  AppBar appBar(double scaleFactor) {
    return AppBar(
      elevation: 0,
      centerTitle: true,
      backgroundColor: Colors.white,
      title: Text(
        "AmBoo",
        style: TextStyle(
            fontSize: 20 * scaleFactor,
            color: primaryColor,
            fontWeight: FontWeight.bold),
      ),
    );
  }
}

void onLoading(context) {
  showDialog(
      context: context,
      useSafeArea: true,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          child: Padding(
            padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.02),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const CircularProgressIndicator(),
                SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                Text(
                  "Authenticating...",
                  style: TextStyle(
                      color: primaryColor,
                      fontSize: 16 * MediaQuery.of(context).textScaleFactor),
                )
              ],
            ),
          ),
        );
      });
}
