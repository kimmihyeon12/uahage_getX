import 'package:get/get.dart';
import 'package:uahage/src/Controller/place.controller.dart';

class PlaceBinding implements Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.put<PlaceController>(PlaceController());
  }
}
