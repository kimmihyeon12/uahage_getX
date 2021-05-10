import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:uahage/src/Controller/user.controller.dart';
import 'package:uahage/src/Static/url.dart';
import 'package:http/http.dart' as http;

class user extends GetView<UserController> {
  String url = URL;
  //ALL SELECT
  select() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    try {
      var response = await http.get(
          url + "/api/users/${controller.userId.value}",
          headers: <String, String>{"Authorization": controller.token.value});

      if (jsonDecode(response.body)['message'] == 'finded successfully') {
        var data = jsonDecode(response.body)['data']["result"][0];

        return {
          "nickname": data["nickname"] == null ? "" : data["nickname"],
          "baby_birthday":
              data["baby_birthday"] == null ? "" : data["baby_birthday"],
          "baby_gender": data["baby_gender"] == null ? "" : data["baby_gender"],
          "age": data["parent_age"] == null ? "" : data["parent_age"],
          "profile_url": data["profile_url"] == null ? "" : data["profile_url"],
        };
      }
    } catch (err) {
      print(err);
    }
  }

  //INSERT
  insert() {
    //SIGN UP 에서 INSERT 함
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
  Future updataUser(nickName, gender, birthday, age) async {
    try {
      Map<String, dynamic> userData = {
        "email": "'${controller.email.value}${controller.option.value}'",
        "nickname": "'${nickName}'",
        "gender": "'${gender}'",
        "birthday": "'${birthday}'",
        "age": age,
        "rf_token": UserController.to.token.value,
      };
      print(userData);
      var response = await http.put(
        url + "/api/users/${UserController.to.userId.value}",
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          "Authorization": UserController.to.token.value
        },
        body: jsonEncode(userData),
      );
      return response.statusCode == 200
          ? jsonDecode(response.body)["message"]
          : Future.error(jsonDecode(response.body)["error"]);
    } catch (err) {
      return Future.error(err);
    }
  }

// SELECT OPTION
  //CHECK THE EMAIL
  Future checkEmail() async {
    var response = await http.get(url +
        "/api/users/find-by-option?option=email&optionData='${controller.email.value}${controller.option.value}'");
    return jsonDecode(response.body)["isdata"] == 0 ? true : false;
  }

  //CHECK THE NICKNAME

  Future checkNickName(nickName) async {
    try {
      var response = await http.get(
        url +
            "/api/users/find-by-option?option=nickname&optionData='${nickName}'",
      );
      print("isdata nickname" + jsonDecode(response.body)["isdata"].toString());
      if (jsonDecode(response.body)["isdata"] == 0) {
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
