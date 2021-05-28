import 'package:get/get.dart';

class UserController extends GetxService {
  static UserController get to => Get.find();
  final userId = ''.obs;
  final kakaotoken = ''.obs;
  final navertoken = ''.obs;
  final email = ''.obs;
  final option = ''.obs;
  final token = ''.obs;
  void setUserid(String userid) {
    userId(userid);
  }

  void setKakaoToken(String value) {
    kakaotoken(value);
  }

  void setNaverToken(String value) {
    navertoken(value);
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
