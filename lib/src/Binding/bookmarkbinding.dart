import 'package:get/get.dart';
import 'package:uahage/src/Controller/bookmark.controller.dart';

class BookmarkBinding implements Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.put(BookmarkController);
  }
}
