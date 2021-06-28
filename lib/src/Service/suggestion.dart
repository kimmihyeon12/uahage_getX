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
      'Authorization': "${UserController.to.token.value}"
    };

    var response = await dio.post(
      url + "/api/places/propose",
      data: formdata,
    );

    return response.statusCode == 200 ? "성공" : "실패";
  } catch (err) {
    return Future.error(err);
  }
}

suggestionFormData(placeId, placeCategoryId, text, uploadingImage) async {
  FormData formData = FormData.fromMap({
    "userId": UserController.to.userId.toString(),
    "placeCategoryId": placeCategoryId,
    "placeId": placeId,
    "desc": text,
  });
  for (int i = 0; i < uploadingImage.length; i++) {
    formData.files.add(MapEntry(
      "images",
      MultipartFile.fromFileSync(
        uploadingImage[i].path,
        filename: uploadingImage[i].path.split('/').last,
      ),
    ));
  }

  return formData;
}
