import 'package:flutter_config/flutter_config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import 'package:uahage/src/Controller/login.controller.dart';

class auth extends GetView<loginCotroller> {
  String url = FlutterConfig.get('API_URL');

  Future signIn(Email, loginOption) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String userId;

    Map<String, dynamic> userData = {
      "email": "'$Email$loginOption'",
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
      userId = data['data']['id'].toString();

      //save user info
      await sharedPreferences.setString("uahageUserToken", token);
      await sharedPreferences.setString("uahageUserId", userId);
      return {"userId": userId, "token": token};
    }
  }

  //REGISTER
  Future signUp(
      type, Email, loginOption, nickName, gender, birthday, userAge) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String userId;
    bool saveError = true;
    Map<String, dynamic> userData = type == "withNickname"
        ? {
            "email": "'$Email$loginOption'",
            "nickname": "'$nickName'",
            "gender": "'$gender'",
            "birthday": "'$birthday'",
            "age": userAge,
            "URL": null,
            "rf_token": null
          }
        : {
            "email": "'$Email$loginOption'",
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
        userId = data['data']['id'].toString();

        //save user info
        await sharedPreferences.setString("uahageUserToken", token);
        await sharedPreferences.setString("uahageUserId", userId);
        return {"userId": userId, "token": token};
      } else {
        return saveError;
      }
    } catch (error) {
      return Future.error(error);
    }
  }

  //CHECK THE EMAIL
  Future checkEmail(Email, loginOption) async {
    var response = await http.get(url +
        "/api/users/find-by-option?option=email&optionData='${Email}${loginOption}'");
    return jsonDecode(response.body)["isdata"] == 0 ? true : false;
  }

//CHECK THE NICKNAME
  Future checkNickName(nickName) async {
    bool isIdValid = false;

    try {
      var response = await http.get(
        url +
            "/api/users/find-by-option?option=nickname&optionData='${nickName}'",
      );
      print("isdata nickname" + jsonDecode(response.body)["isdata"].toString());
      if (jsonDecode(response.body)["isdata"] == 0) {
        isIdValid = true;

        return isIdValid;
      } else {
        isIdValid = false;

        return isIdValid;
      }
    } catch (err) {
      print(err);
      return Future.error(err);
    }
  }

  @override
  Widget build(BuildContext context) {
    Get.put(controller);
    return Container();
  }
}
