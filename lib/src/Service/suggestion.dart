import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:uahage/src/Controller/user.controller.dart';
import 'package:uahage/src/Static/url.dart';
import 'package:http/http.dart' as http;

revisesuggestion(formdata) async {
  String url = URL;
  try {
    var dio = new Dio();
    dio.options.headers = {
      'Content-Type': 'application/json',
      'Authorization': "bearer ${UserController.to.token.value}"
    };

    var response = await dio.post(
      url + "/places/proposes",
      data: formdata,
    );

    return response.statusCode == 200 ? "성공" : "실패";
  } catch (err) {
    return Future.error(err);
  }
}
