import 'package:get/get.dart';
import 'package:uahage/src/Controller/image.controller.dart';

class ImageBinding implements Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.put(ImageController());
  }
}
