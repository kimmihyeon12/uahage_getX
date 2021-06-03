import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class ConnectionController extends GetxService {
  static ConnectionController get to => Get.find();

  RxString connectionstauts = "".obs;

  void connectionState(value) {
    connectionstauts(value);
  }
}
