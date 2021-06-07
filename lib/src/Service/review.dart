//UPDATE
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:uahage/src/Static/url.dart';

Future reviewInsert(formdata) async {
  String url = URL;
  try {
    print("폼데이터");

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

reviewSelectImage(placeId) async {
  String url = URL;
  try {
    var response = await http.get(
      Uri.parse(url + "/api/places/restaurants/${placeId}/reviews?order=DATE"),
      // headers: <String, String>{"Authorization": controller.token.value}
    );

    return jsonDecode(response.body)["data"];
  } catch (err) {
    return Future.error(err);
  }
}
