import 'package:get/get.dart';
import 'package:uahage/src/Controller/user.controller.dart';

class UserBinding implements Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.put(UserController);
  }
}
