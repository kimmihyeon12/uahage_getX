import 'package:get/get.dart';
import 'package:uahage/src/Model/restaurant.dart';
import 'package:uahage/src/Model/starHelper.dart';

class BookmarkController extends GetxService {
  static BookmarkController get to => Get.find();

  RxList placeBookmark = <Restaurant>[].obs;
  RxInt subBookmark = 0.obs;
  setSubBookmark(value) {
    subBookmark(value);
  }

  placeBookmarkInit() {
    placeBookmark(<Restaurant>[]);
  }

  setPlaceBookmark(placedata) {
    placeBookmark.add(placedata);
  }

  setPlaceBookmarkOne(index, value) {
    placeBookmark[index].bookmark = value;
    placeBookmark.refresh();
  }

  starPlaceBookmarkrefresh(index) {
    placeBookmark.removeAt(index);
    placeBookmark.refresh();
  }
}
