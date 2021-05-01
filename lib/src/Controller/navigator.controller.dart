import 'package:get/get.dart';

class navigatorController extends GetxService {
  static navigatorController get to => Get.find();
  RxInt currentIndex = 0.obs;

  void changePageIndex(int index) {
    currentIndex(index);
  }
}
