import 'package:get/get.dart';

import 'package:uahage/src/Controller/url.controller.dart';

class UrlBinding implements Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.put(UrlController);
  }
}
