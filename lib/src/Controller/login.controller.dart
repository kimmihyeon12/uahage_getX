import 'package:get/get.dart';

class LoginCotroller extends GetxService {
  static LoginCotroller get to => Get.find();
  final installed = false.obs;
  final register = false.obs;

  final emails = ''.obs;
  final loginOption = ''.obs;

  final userId = ''.obs;
  final tokens = ''.obs;

  final nicknames = ''.obs;
  final genders = ''.obs;
  final girl = true.obs;
  final boy = true.obs;
  final birthdays = ''.obs;
  final ages = 0.obs;
  final error = false.obs;
  final isIdValid = false.obs;

  final imageLink = ''.obs;
  final fileimage = ''.obs;

  void initsetting() {
    installed(false);
    register(false);
    userId('');
    tokens('');
    emails('');
    loginOption('');
    nicknames('');
    genders('');
    girl(true);
    boy(true);
    birthdays('');
    ages(0);
    error(false);
    isIdValid(false);
    imageLink('');
    fileimage('');
  }

  void installedstate(bool state) {
    installed(state);
  }

  void registerstate(bool state) {
    register(state);
  }

  void errorstate(bool state) {
    error(state);
  }

  void idValidstate(bool state) {
    isIdValid(state);
  }

  void setEmail(String email) {
    emails(email);
  }

  void setUserid(String userid) {
    userId(userid);
  }

  void setToken(String token) {
    tokens(token);
  }

  void setLoginOption(String option) {
    loginOption(option);
  }

  void setnickname(String nickname) {
    nicknames(nickname);
  }

  void setimage(String image) {
    imageLink(image);
  }

  void setfileimage(image) {
    imageLink(image);
  }

  void setgender(String gender) {
    genders(gender);
  }

  void setbirthday(String birthday) {
    birthdays(birthday);
  }

  void setage(int age) {
    ages(age);
  }

  void setGenderColor(String value) {
    if (value == 'M') {
      if (boy == true) {
        genders(value);
        boy(false);
        girl(true);
      }
    }
    if (value == 'F') {
      if (girl == true) {
        genders(value);
        boy(true);
        girl(false);
      }
    }
  }
}
