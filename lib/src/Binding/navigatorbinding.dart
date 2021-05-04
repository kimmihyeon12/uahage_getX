import 'package:get/get.dart';
import 'package:uahage/src/Controller/navigator.controller.dart';

import '../Controller/navigator.controller.dart';

class NavigationBiding implements Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.put(NavigatorController());
  }
}
