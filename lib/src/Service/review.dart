//UPDATE
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:uahage/src/Controller/review.controller.dart';
import 'package:uahage/src/Model/review.dart';
import 'package:uahage/src/Static/url.dart';

Future reviewInsert(formdata) async {
  String url = URL;
  try {
    var dio = new Dio();
    var response = await dio.post(
      url + "/api/places/restaurants/reviews",
      data: formdata,
    );
    return response.statusCode == 200 ? "성공" : "실패";
  } catch (err) {
    return Future.error(err);
  }
}

reviewSelect(placeId) async {
  String url = URL;
  var currentData;
  try {
    var response = await http.get(
      Uri.parse(url + "/api/places/restaurants/${placeId}/reviews?order=DATE"),
      // headers: <String, String>{"Authorization": controller.token.value}
    );
    // var jsonDate = await jsonDecode(response.body)["data"]["data"];
    // for (var data in jsonDate) {
    //   currentData = Review.fromJson(data);
    // }

    // await ReviewController.to.setReview(currentData);
    return jsonDecode(response.body)["data"];
  } catch (err) {
    return Future.error(err);
  }
}

reviewSelectImage(placeId) async {
  String url = URL;
  try {
    var response = await http.get(
      Uri.parse(url + "/api/places/restaurants/${placeId}/reviews?type=img"),
      // headers: <String, String>{"Authorization": controller.token.value}
    );
    return jsonDecode(response.body)["data"]["data"];
  } catch (err) {
    return Future.error(err);
  }
}
