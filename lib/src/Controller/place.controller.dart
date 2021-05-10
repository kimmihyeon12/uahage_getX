import 'package:get/get.dart';

class PlaceController extends GetxService {
  static PlaceController get to => Get.find();

  RxList place = <dynamic>[].obs;
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

  setPlaceBookmark(int index, int value) {
    print('bookmark index $index');
    place[index].bookmark = value;
  }
}
