import 'package:get/get.dart';
import 'package:uahage/src/Model/restaurant.dart';

class PlaceController extends GetxService {
  static PlaceController get to => Get.find();

  RxList place = <dynamic>[].obs;
  RxList placeRestaurantBookmark = <Restaurant>[].obs;
  RxInt placePageNumber = 1.obs;
  RxInt indexCount = 0.obs;

  void changeindexCount(int index) {
    indexCount(index);
  }

  placeInit() {
    place(<dynamic>[]);
    indexCount(0);
    placePageNumber(1);
  }

  setPlace(placedata) {
    place.add(placedata);
  }

  setPlacePaceNumber() {
    placePageNumber++;
  }

  setPlaceBookmark(int index, bool value) {
    print('bookmark index $index');
    place[index].isBookmarked = value;
    place.refresh();
  }

  setPlacetotal(int index, String value) {
    print('bookmark index $value');
    place[index].total = value;
    place.refresh();
  }
}
