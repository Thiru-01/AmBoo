import 'package:amboo/constant.dart';
import 'package:amboo/controller/datacontroller.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'pages/songpage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'AmBoo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primarySwatch: primaryColor, scaffoldBackgroundColor: Colors.white),
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
                            onSaved: (_token) {
                              tokenController.getToken(_token ?? 'empty');
                              Get.off(() => const SongPage());
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
