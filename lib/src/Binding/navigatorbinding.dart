import 'package:get/get.dart';
import 'package:uahage/src/Controller/navigator.controller.dart';

class NavigationBinding implements Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.put(NavigatorController());
  }
}
