import 'package:uahage/src/Controller/user.controller.dart';
import 'package:uahage/src/Static/url.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';

class Auth extends GetView<UserController> {
  String url = URL;

  Future signIn() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    Map<String, dynamic> userData = {
      "email": "'${controller.email.value}${controller.option.value}'",
    };
    var response = await http.post(
      url + "/api/auth/signin",
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(userData),
    );
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      String token = data['data']['token'];
      String userId = data['data']['id'].toString();
      controller.setUserid(userId);
      controller.setToken(token);

      //save user info
      await sharedPreferences.setString("token", token);
      await sharedPreferences.setString("userId", userId);

      return true;
    }
  }

  //REGISTER
  Future signUp(String type, nickName, gender, birthday, age) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    Map<String, dynamic> userData = type == "withNickname"
        ? {
            "email": "'${controller.email.value}${controller.option.value}'",
            "nickname": "'${nickName}'",
            "gender": "'${gender}'",
            "birthday": "'${birthday}'",
            "age": age,
            "URL": null,
            "rf_token": null
          }
        : {
            "email": "'${controller.email.value}${controller.option.value}'",
            "nickname": null,
            "gender": null,
            "birthday": null,
            "age": null,
            "URL": null,
            "rf_token": null
          };

    try {
      var response = await http.post(
        url + "/api/auth/signup",
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(userData),
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        String token = data['data']['token'];
        String userId = data['data']['id'].toString();

        //save user info
        await sharedPreferences.setString("uahageUserToken", token);
        await sharedPreferences.setString("uahageUserId", userId);

        controller.setUserid(userId);
        controller.setToken(token);

        return data["message"];
      } else {
        //  controller.errorstate(true);
        return Future.error(jsonDecode(response.body)["message"]);
      }
    } catch (error) {
      return Future.error(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    Get.put(controller);
    return Container();
  }
}
