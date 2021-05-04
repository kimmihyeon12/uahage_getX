import 'package:get/get.dart';

class UrlController extends GetxService {
  static UrlController get to => Get.find();
  final url = ''.obs;

  void changeUrl(String currenturl) {
    url(currenturl);
  }
}
