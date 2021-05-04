import 'package:get/get.dart';

class LocationController extends GetxService {
  static LocationController get to => Get.find();

  RxString lat = "".obs;
  RxString lon = "".obs;
  void setLocation(String latitude, String longitude) {
    lat(latitude);
    lon(longitude);
  }
}
