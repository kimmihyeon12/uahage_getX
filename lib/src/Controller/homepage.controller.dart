import 'package:get/get.dart';

class homeContoller extends GetxService {
  static homeContoller get to => Get.find();
  RxInt currentIndex = 1.obs;
  RxString textfield = "".obs;

  void changePageIndex(int index) {
    if (index < 6) currentIndex(index);
  }

  void changeTextField(String text) {
    textfield(text);
  }
}
