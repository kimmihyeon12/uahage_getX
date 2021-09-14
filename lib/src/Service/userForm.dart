import 'package:dio/dio.dart';
import 'package:uahage/src/Controller/user.controller.dart';

userForm(nickname, babyGenders, babyBirthdays, ageGroupType) async {
  FormData formData = FormData.fromMap({
    "nickname": nickname,
    "babyGenders": babyGenders,
    "babyBirthdays": babyBirthdays,
    "ageGroupType": ageGroupType,
  });

  return formData;
}
