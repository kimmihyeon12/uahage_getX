import 'package:get/get.dart';
import 'package:uahage/src/Controller/login.controller.dart';

class LoginBinding implements Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.put(LoginCotroller());
  }
}
