import 'package:get/get.dart';

import 'package:uahage/src/Controller/location.controller.dart';

class LocationBinding implements Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.put(LocationController());
  }
}
