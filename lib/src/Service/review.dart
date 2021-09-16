//UPDATE
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:uahage/src/Controller/review.controller.dart';
import 'package:uahage/src/Controller/user.controller.dart';
import 'package:uahage/src/Model/review.dart';
import 'package:uahage/src/Static/url.dart';

Future reviewInsert(formdata) async {
  String url = URL;
  try {
    var dio = new Dio();
    dio.options.headers = {
      'Content-Type': 'application/json',
      'Authorization': "${UserController.to.token.value}"
    };

    var response = await dio.post(
      url + "/places/restaurants/reviews",
      data: formdata,
    );
    return response.statusCode == 200 ? "성공" : "실패";
  } catch (err) {
    return Future.error(err);
  }
}

reviewSelect(placeId, order) async {
  String url = URL;
  var currentData;
  try {
    var response = await http.get(
      url + "/places/restaurants/reviews?order=$order&placeId=${placeId}",
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': '${UserController.to.token.value}'
      },
    );

    return jsonDecode(utf8.decode(response.bodyBytes));
  } catch (err) {
    return Future.error(err);
  }
}

reviewSelectImage(placeId) async {
  String url = URL;
  try {
    var response = await http.get(
      Uri.parse(url +
          "/places/restaurants/reviews?type=img&order=date&placeId=${placeId}"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': '${UserController.to.token.value}'
      },
    );
    return jsonDecode(response.body)["reviews"];
  } catch (err) {
    return Future.error(err);
  }
}

reviewDelete(reviewId) async {
  String url = URL;
  try {
    var response = await http.delete(
      Uri.parse(url + "/places/restaurants/reviews/${reviewId}"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': '${UserController.to.token.value}'
      },
    );
    return "정말 삭제하시겠습니까?";
  } catch (err) {
    return Future.error(err);
  }
}

reviewUpdate(reviewId, formdata) async {
  String url = URL;
  try {
    var dio = new Dio();
    dio.options.headers = {
      'Content-Type': 'application/json',
      'Authorization': "${UserController.to.token.value}"
    };

    var response = await dio.put(
      url + "/places/restaurants/reviews/${reviewId}",
      data: formdata,
    );
    return response.statusCode == 200 ? "성공" : "실패";
  } catch (err) {
    return Future.error(err);
  }
}

reviewUpdateFormdata(uploadingImage, desc, tasteRating, costRating,
    serviceRating, deleteImage) async {
  FormData formData = FormData.fromMap({
    "desc": desc,
    "tasteRating": tasteRating,
    "costRating": costRating,
    "serviceRating": serviceRating,
    "deleteImgIds": deleteImage,
    "userId": UserController.to.userId,
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

insertFormData(placeId, text, taste, cost, service, uploadingImage) async {
  FormData formData = FormData.fromMap({
    "userId": UserController.to.userId.toString(),
    "placeId": placeId,
    "desc": text,
    "tasteRating": taste,
    "costRating": cost,
    "serviceRating": service,
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
