import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:uahage/src/Controller/user.controller.dart';
import 'package:uahage/src/Service/userForm.dart';
import 'package:uahage/src/Static/url.dart';
import 'package:http/http.dart' as http;

class Users extends GetView<UserController> {
  String url = URL;
  //ALL SELECT
  select() async {
    print("userid ${controller.userId.value}");
    try {
      var response = await http.get(
        Uri.parse(url + "/users/${controller.userId.value}"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': '${UserController.to.token.value}'
        },
      );

      var data = await jsonDecode(utf8.decode(response.bodyBytes))["user"];
      return data;
    } catch (err) {
      print(err);
    }
  }

  //INSERT
  Future insert(
      String type, nickname, babyGenders, babyBirthdays, ageGroupType) async {
    print('회원가입 및 로그인');
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var formdata =
        await userForm(nickname, babyGenders, babyBirthdays, ageGroupType);
    print(formdata);

    try {
      var response;
      print(UserController.to.option);
      if (UserController.to.option == "KAKAO") {
        var dio = new Dio();
        dio.options.headers = {
          'Content-Type': 'application/json',
          'Authorization': 'bearer ${controller.kakaotoken.value}'
        };
        if (type == null) {
          //이미 이메일이 있는경우
          //토큰 발급용
          response = await dio.post(url + "/users/kakao-login", data: null);
        } else {
          response = await dio.post(
            url + "/users/kakao-login",
            data: formdata,
          );
        }
      } else {
        var dio = new Dio();
        dio.options.headers = {
          'Content-Type': 'application/json',
          'Authorization': 'bearer ${controller.kakaotoken.value}'
        };

        response = await dio.post(
          url + "/users/naver-login",
          data: formdata,
        );
      }

      if (response.statusCode == 200) {
        String token = response.data["data"]["accessToken"];
        print(token);
        //token decode
        String foo = token.split('.')[1];
        List<int> res = base64.decode(base64.normalize(foo));
        Map<dynamic, dynamic> result = jsonDecode(utf8.decode(res));

        //save user info
        await sharedPreferences.setString("uahageUserToken", token.toString());
        await sharedPreferences.setString(
            "uahageUserId", result["id"].toString());

        controller.setUserid(result["id"].toString());
        controller.setToken(token.toString());

        print('${controller.userId.value} ${controller.token.value}');

        return response.data["message"];
      } else {
        return Future.error(response.data["message"]);
      }
    } catch (error) {
      return Future.error(error);
    }
  }

  //DELETE
  delete() async {
    var response = await http.delete(
      Uri.parse(url + "/users/${controller.userId.value}"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': '${controller.token.value}'
      },
    );
    return jsonDecode(utf8.decode(response.bodyBytes))["message"];
  }

  //UPDATE
  Future update(formdata) async {
    try {
      var dio = new Dio();
      dio.options.headers = {
        'Content-Type': 'application/json',
        'Authorization': "${UserController.to.token.value}"
      };
      var response = await dio.put(
        url + "/users/${UserController.to.userId.value}",
        data: formdata,
      );
      return response.statusCode == 200 ? "성공" : "실패";
    } catch (err) {
      return Future.error(err);
    }
  }

// SELECT OPTION
  //CHECK THE EMAIL
  Future checkEmail() async {
    print("이메일 체크");
    print(url +
        "/users/verify-duplicate-email/${controller.option.value}:${controller.email.value}");
    var response = await http.get(
      Uri.parse(url +
          "/users/verify-duplicate-email/${controller.option.value}:${controller.email.value}"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': '${UserController.to.token.value}'
      },
    );

    return jsonDecode(utf8.decode(response.bodyBytes))["available"];
  }

//${controller.email.value}${controller.option.value}
  //CHECK THE NICKNAME
  Future checkNickName(nickName) async {
    print("닉네임 체크");
    try {
      var response = await http.get(
        Uri.parse(
          url + "/users/verify-duplicate-nickname/${nickName}",
        ),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': '${UserController.to.token.value}'
        },
      );
      print(jsonDecode(utf8.decode(response.bodyBytes)));
      if (jsonDecode(utf8.decode(response.bodyBytes))['statusCode'] == 200) {
        if (jsonDecode(utf8.decode(response.bodyBytes))["available"]) {
          return {"idValid": true, "value": "사용 가능한 닉네임입니다."};
        } else {
          return {
            "idValid": false,
            "value": jsonDecode(utf8.decode(response.bodyBytes))["message"]
          };
        }
      } else {
        return {
          "idValid": false,
          "value": jsonDecode(utf8.decode(response.bodyBytes))["message"]
        };
      }
    } catch (err) {
      print(err);
      return Future.error(err);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

isNicknameCheck() async {
  String url = URL;
  try {
    var response = await http.get(
      Uri.parse(
        url + "/users/${UserController.to.userId.value}/nickname",
      ),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': '${UserController.to.token.value}'
      },
    );

    return jsonDecode(response.body)["data"]["nickname"] == null ? false : true;
  } catch (err) {
    print(err);
    return Future.error(err);
  }
}
