import 'package:get/get.dart';

class LoginCotroller extends GetxService {
  static LoginCotroller get to => Get.find();
  final installed = false.obs;
  final register = false.obs;
  final userId = ''.obs;
  final tokens = ''.obs;
  final emails = ''.obs;
  final loginOption = ''.obs;
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
  final check = <bool>[false, false, false, false].obs;
  final ageImage = <bool>[false, false, false, false, false, false].obs;

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

  void setcheck(List checked) {
    check(checked);
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

  void setAgeColor(int age) {
    if (age == 10) {
      ages(10);
      ageImage[0] = true;
      ageImage[1] = false;
      ageImage[2] = false;
      ageImage[3] = false;
      ageImage[4] = false;
      ageImage[5] = false;
    } else if (age == 20) {
      ages(20);
      ageImage[0] = false;
      ageImage[1] = true;
      ageImage[2] = false;
      ageImage[3] = false;
      ageImage[4] = false;
      ageImage[5] = false;
    } else if (age == 30) {
      ages(30);
      ageImage[0] = false;
      ageImage[1] = false;
      ageImage[2] = true;
      ageImage[3] = false;
      ageImage[4] = false;
      ageImage[5] = false;
    } else if (age == 40) {
      ages(40);
      ageImage[0] = false;
      ageImage[1] = false;
      ageImage[2] = false;
      ageImage[3] = true;
      ageImage[4] = false;
      ageImage[5] = false;
    } else if (age == 50) {
      ages(50);
      ageImage[0] = false;
      ageImage[1] = false;
      ageImage[2] = false;
      ageImage[3] = false;
      ageImage[4] = true;
      ageImage[5] = false;
    } else {
      ages(60);
      ageImage[0] = false;
      ageImage[1] = false;
      ageImage[2] = false;
      ageImage[3] = false;
      ageImage[4] = false;
      ageImage[5] = true;
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
