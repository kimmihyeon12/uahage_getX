import 'package:get/get.dart';
import 'package:uahage/src/Model/starHelper.dart';

class BookmarkController extends GetxService {
  static BookmarkController get to => Get.find();

  RxList starList = <StarList>[].obs;

  starListInit() {
    starList(<StarList>[]);
  }

  setStarList(placedata) {
    starList.add(placedata);
  }

  starListrefresh(index) {
    starList.removeAt(index);
    starList.refresh();
  }
}
