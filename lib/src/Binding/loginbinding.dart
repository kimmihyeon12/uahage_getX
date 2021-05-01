import 'package:get/get.dart';
import 'package:uahage_getx/src/Controller/login.controller.dart';

class loginBinding implements Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.put(loginCotroller());
  }
}
