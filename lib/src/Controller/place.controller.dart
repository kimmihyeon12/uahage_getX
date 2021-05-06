import 'package:get/get.dart';

class PlaceController extends GetxService {
  static PlaceController get to => Get.find();

  final place = <dynamic>[].obs;
  RxInt placePageNumber = 0.obs;
  placeInit() {
    place(<dynamic>[]);
    placePageNumber(0);
  }

  setPlace(placedata) {
    place.add(placedata);
  }

  setPlacePaceNumber() {
    placePageNumber++;
  }
}
