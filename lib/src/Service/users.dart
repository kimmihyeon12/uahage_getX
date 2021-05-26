import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:uahage/src/Controller/user.controller.dart';
import 'package:uahage/src/Static/url.dart';
import 'package:http/http.dart' as http;

class Users extends GetView<UserController> {
  String url = URL;
  //ALL SELECT
  select() async {
    print("회원보기");
    print("userid ${controller.userId.value}");
    try {
      var response = await http.get(
        url + "/api/users/${controller.userId.value}",
        // headers: <String, String>{"Authorization": controller.token.value}
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body)['data'];

        return {
          "nickname": data["nickname"] == null ? "" : data["nickname"],
          "baby_birthday":
              data["baby_birthday"] == null ? "" : data["baby_birthday"],
          "baby_gender": data["baby_gender"] == null ? "" : data["baby_gender"],
          "age_group_type":
              data["age_group_type"] == null ? "" : data["age_group_type"],
          "image_path": data["image_path"] == null ? "" : data["image_path"],
        };
      }
    } catch (err) {
      print(err);
    }
  }

  //INSERT
  Future insert(
      String type, nickname, babyGender, babyBirthday, ageGroupType) async {
    print('회원가입 및 로그인');
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    Map<String, dynamic> userData = type == "withNickname"
        ? {
            "providerName": "KAKAO",
            "nickname": "${nickname}",
            "babyGender": "${babyGender}",
            "babyBirthday": "${babyBirthday}",
            "ageGroupType": ageGroupType,
          }
        : {
            "providerName": "KAKAO",
          };

    try {
      var response = await http.post(
        url + "/api/users/kakao-login",
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': '${controller.kakaotoken.value}'
        },
        body: jsonEncode(userData),
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        String token = data['data']['token'];

        //token decode
        String foo = token.split('.')[1];
        List<int> res = base64.decode(base64.normalize(foo));
        Map<dynamic, dynamic> result = jsonDecode(utf8.decode(res));

        //save user info
        await sharedPreferences.setString("uahageUserToken", token.toString());
        await sharedPreferences.setString(
            "uahageUserId", result["uid"].toString());

        controller.setUserid(result["uid"].toString());
        controller.setToken(token.toString());

        print('${controller.userId.value} ${controller.token.value}');

        return data["message"];
      } else {
        //  controller.errorstate(true);
        return Future.error(jsonDecode(response.body)["message"]);
      }
    } catch (error) {
      return Future.error(error);
    }
  }

  //DELETE
  delete(imageLink) async {
    if (imageLink != "") {
      try {
        await http.post(
          url + "/api/profile/deleteImage",
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode({"fileName": imageLink}),
        );
      } catch (err) {}
    }

    try {
      var res = await http.delete(url + "/api/users/${controller.userId.value}",
          headers: <String, String>{"Authorization": controller.token.value});
      var data = jsonDecode(res.body);
      if (res.statusCode == 200) {
        return data["message"];
      } else {
        throw (data["message"]);
      }
    } catch (e) {
      return Future.error(e);
    }
  }

  //UPDATE
  Future update(formdata) async {
    try {
      /*  Map<String, dynamic> userData = {
        "image": image,
        "imgInit": "y",
        "nickname": "${nickName}",
        "ageGroupType": age,
        "babyGender": "${gender}",
        "babyBirthday": "${birthday}",
      };*/
      print(formdata);
      var dio = new Dio();
      var response = await dio.put(
          url + "/api/users/${UserController.to.userId.value}",
          data: formdata
          /* headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          "Authorization": UserController.to.token.value
        },
        body: jsonEncode(userData),*/
          );
      /*return response.statusCode == 200
          ? jsonDecode(response.body)["message"]
          : Future.error(jsonDecode(response.body)["error"]);*/
      return response.statusCode == 200 ? "성공" : "실패";
    } catch (err) {
      return Future.error(err);
    }
  }

// SELECT OPTION
  //CHECK THE EMAIL
  Future checkEmail() async {
    print("이메일 체크");
    var response = await http.get(url +
        "/api/users/validate-email/${controller.option.value}.${controller.email.value}");
    return jsonDecode(response.body)["data"];
  }

//${controller.email.value}${controller.option.value}
  //CHECK THE NICKNAME
  Future checkNickName(nickName) async {
    print("닉네임 체크");
    try {
      var response = await http.get(
        url + "/api/users/validate-nickname/${nickName}",
      );
      print("isdata nickname" + jsonDecode(response.body)["data"].toString());
      if (jsonDecode(response.body)["data"]) {
        return {"idValid": true, "value": "사용 가능한 닉네임입니다."};
      } else {
        return {"idValid": false, "value": "이미 사용중인 닉네임입니다."};
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
