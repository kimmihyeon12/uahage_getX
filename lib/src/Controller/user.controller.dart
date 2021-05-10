import 'package:get/get.dart';

class UserController extends GetxService {
  static UserController get to => Get.find();
  final userId = ''.obs;
  final token = ''.obs;
  final email = ''.obs;
  final option = ''.obs;

  void setUserid(String userid) {
    userId(userid);
  }

  void setToken(String value) {
    token(value);
  }

  void setEmail(String value) {
    email(value);
  }

  void setOption(String value) {
    option(value);
  }
}
