// ignore_for_file: invalid_use_of_protected_member

import 'package:get/get.dart';

class DataController extends GetxController {
  RxMap<dynamic, dynamic> content = {}.obs;
  var token = ''.obs;
  getToken(String userToken) {
    print(token);
  }

  setContent(String name, dynamic data) {
    content.value.addIf(!content.value.containsKey(name), name, data);
  }

  setContentEmpty() {
    content.clear();
  }
}
