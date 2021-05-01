import 'package:get/get.dart';
import 'package:uahage_getx/src/Controller/homepage.controller.dart';

class homebinding implements Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.put(homeContoller());
  }
}
