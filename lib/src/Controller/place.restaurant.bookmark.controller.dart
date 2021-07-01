import 'package:get/get.dart';
import 'package:uahage/src/Model/restaurant.dart';
import 'package:uahage/src/Model/starHelper.dart';

class BookmarkController extends GetxService {
  static BookmarkController get to => Get.find();

  RxList placeBookmark = <Restaurant>[].obs;

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

  setPlacetotal(int index, String value) {
    print('bookmark index $value');
    placeBookmark[index].total = value;
    placeBookmark.refresh();
  }

  starPlaceBookmarkrefresh(index) {
    placeBookmark.removeAt(index);
    placeBookmark.refresh();
  }
}
