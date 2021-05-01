import 'package:get/get.dart';

class loginCotroller extends GetxService {
  static loginCotroller get to => Get.find();
  final installed = false.obs;
  final register = false.obs;
  final userId = ''.obs;
  final tokens = ''.obs;
  final emails = ''.obs;
  final loginOption = ''.obs;

  final nicknames = ''.obs;
  final genders = ''.obs;
  final girl = false.obs;
  final boy = false.obs;
  final birthdays = ''.obs;
  final ages = 0.obs;
  final error = false.obs;
  final isIdValid = false.obs;

  final check = <bool>[false, false, false, false].obs;
  final ageImage = <bool>[false, false, false, false, false, false].obs;

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

  void setcheck(List checked) {
    check(checked);
  }

  void setnickname(String nickname) {
    nicknames(nickname);
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

  void setAgeColor(int age) {
    if (age == 10) {
      ages(10);
      List<bool> image;
      image[0] = true;
      image[1] = false;
      image[2] = false;
      image[3] = false;
      image[4] = false;
      image[5] = false;
      ageImage(image);
    } else if (age == 20) {
      ages(20);
      List<bool> image;
      image[0] = false;
      image[1] = true;
      image[2] = false;
      image[3] = false;
      image[4] = false;
      image[5] = false;
      ageImage(image);
    } else if (age == 30) {
      ages(30);
      List<bool> image;
      image[0] = false;
      image[1] = false;
      image[2] = true;
      image[3] = false;
      image[4] = false;
      image[5] = false;
      ageImage(image);
    } else if (age == 40) {
      ages(40);
      List<bool> image;
      image[0] = false;
      image[1] = false;
      image[2] = false;
      image[3] = true;
      image[4] = false;
      image[5] = false;
      ageImage(image);
    } else if (age == 50) {
      ages(50);
      List<bool> image;
      image[0] = false;
      image[1] = false;
      image[2] = false;
      image[3] = false;
      image[4] = true;
      image[5] = false;
      ageImage(image);
    } else {
      ages(60);
      List<bool> image;
      image[0] = false;
      image[1] = false;
      image[2] = false;
      image[3] = false;
      image[4] = false;
      image[5] = true;
      ageImage(image);
    }
  }

  void setChecked(int number, bool state) {
    if (number == 0) {
      print('number');
      if (state == false) {
        check[0] = false;
        check[1] = false;
        check[2] = false;
        check[3] = false;
      } else {
        check[0] = true;
        check[1] = true;
        check[2] = true;
        check[3] = true;
      }
    } else {
      check[number] = state;
    }
    if (check[1] && check[2] && check[3]) {
      check[0] = true;
    } else {
      check[0] = false;
    }
  }
}
