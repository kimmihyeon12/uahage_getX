import 'package:get/get.dart';
import 'package:uahage/src/Controller/login.controller.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:uahage/src/Static/url.dart';
import 'package:http/http.dart' as http;

class user extends GetView<loginCotroller> {
  String url = URL;
  //ALL SELECT
  select() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    try {
      var response = await http.get(
          url + "/api/users/${controller.userId.value}",
          headers: <String, String>{"Authorization": controller.tokens.value});

      if (jsonDecode(response.body)['message'] == 'finded successfully') {
        var data = jsonDecode(response.body)['data']["result"][0];
        print(data);

        //setting nickname
        controller.setnickname(data["nickname"]);

        // setting baby_birthday
        controller.birthdays(data["baby_birthday"]);

        // setting baby_gender
        if (data['baby_gender'].toString() == "F") {
          controller.setGenderColor('M');
        } else if (data['baby_gender'].toString() == "M") {
          controller.setGenderColor('F');
        }

        // setting age
        controller.setAgeColor(data["parent_age"]);

        // setting image
        controller.setimage(data["profile_url"]);
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
  delete() async {
    if (controller.imageLink.value != "") {
      try {
        await http.post(
          url + "/api/profile/deleteImage",
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode({"fileName": controller.imageLink.value}),
        );
      } catch (err) {}
    }

    try {
      var res = await http.delete(url + "/api/users/${controller.userId.value}",
          headers: <String, String>{"Authorization": controller.tokens.value});
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
  update() async {
    try {
      Map<String, dynamic> userData = {
        "email": "'${controller.emails.value}${controller.loginOption.value}'",
        "nickname": "'${controller.nicknames.value}'",
        "gender": "'${controller.genders.value}'",
        "birthday": "'${controller.birthdays.value}'",
        "age": controller.ages.value,
        "URL": null,
        "rf_token": null
      };
      print(userData);
      var response = await http.put(
        url + "/api/users/${controller.userId.value}",
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          "Authorization": controller.tokens.value
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
        "/api/users/find-by-option?option=email&optionData='${controller.emails.value}${controller.loginOption.value}'");
    return jsonDecode(response.body)["isdata"] == 0 ? true : false;
  }

  //CHECK THE NICKNAME

  Future checkNickName() async {
    try {
      var response = await http.get(
        url +
            "/api/users/find-by-option?option=nickname&optionData='${controller.nicknames.value}'",
      );
      print("isdata nickname" + jsonDecode(response.body)["isdata"].toString());
      if (jsonDecode(response.body)["isdata"] == 0) {
        controller.idValidstate(true);

        return "사용 가능한 닉네임입니다.";
      } else {
        controller.idValidstate(false);
        return "이미 사용중인 닉네임입니다.";
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
