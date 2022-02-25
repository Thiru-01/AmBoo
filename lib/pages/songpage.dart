import 'package:amboo/constant.dart';
import 'package:amboo/controller/datacontroller.dart';
import 'package:amboo/controller/suggestion.dart';
import 'package:amboo/model/spotifymodel.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:spotify_sdk/models/connection_status.dart';
import 'package:spotify_sdk/spotify_sdk.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class SongPage extends StatefulWidget {
  const SongPage({Key? key}) : super(key: key);

  @override
  State<SongPage> createState() => _SongPageState();
}

class _SongPageState extends State<SongPage> {
  DataController controller = Get.put(DataController(), tag: 'dataController');
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
                      TypeAheadField(
                        onSuggestionSelected: (suggestion) {
                          Item item = controller.content[suggestion];
                          controller.setContentEmpty();
                        },
                        suggestionsCallback: (pattern) async {
                          List<String> data = await getSuggestion(pattern);
                          return data;
                        },
                        hideOnEmpty: true,
                        hideOnError: true,
                        itemBuilder: ((context, itemData) {
                          return ListTile(
                              contentPadding: const EdgeInsets.all(6),
                              subtitle: Text(
                                  controller.content[itemData].artists[0].name),
                              title: Text(itemData.toString(),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold)),
                              leading: CachedNetworkImage(
                                imageUrl: controller
                                    .content[itemData].album.images[2].url,
                                height: 80,
                                width: 80,
                              ));
                        }),
                        textFieldConfiguration: TextFieldConfiguration(
                            decoration: InputDecoration(
                                prefix: SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.05),
                                hintText: 'Search',
                                contentPadding: const EdgeInsets.only(
                                  top: 0,
                                  bottom: 0,
                                  left: 0,
                                ),
                                suffixIcon: const Icon(FontAwesomeIcons.search),
                                border: const OutlineInputBorder())),
                      ),
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
                      ),
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

void onLoading(context, String message) {
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
                  message,
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
