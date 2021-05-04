import 'package:get/get.dart';

class ImageController extends GetxService {
  static ImageController get to => Get.find();
  final filter_image = <int>[0, 0, 0, 0, 0, 0, 0, 0, 0].obs;
  final slider = 1.obs;
  final textfield = ''.obs;

  void setFilterImage(int index) {
    if (filter_image[index] == 0)
      filter_image[index] = 1;
    else
      filter_image[index] = 0;
  }

  void initFilterImage() {
    for (var i = 0; i < filter_image.length; i++) {
      filter_image[i] = 0;
    }
  }

  void changeslider(int index) {
    if (index < 6) slider(index);
  }

  void changeTextField(String text) {
    textfield(text);
  }
}
