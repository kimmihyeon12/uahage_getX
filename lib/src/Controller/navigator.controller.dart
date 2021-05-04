import 'package:get/get.dart';

class NavigatorController extends GetxService {
  static NavigatorController get to => Get.find();
  RxInt currentIndex = 0.obs;

  void changePageIndex(int index) {
    currentIndex(index);
  }
}
