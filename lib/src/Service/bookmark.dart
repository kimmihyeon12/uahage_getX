import 'package:flutter_config/flutter_config.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:uahage/src/Static/url.dart';

bookmarkCreate(userId, place_id) async {
  String url = URL;
  var data = {"user_id": userId, "place_id": place_id};
  var response = await http.post(
    url + "/api/bookmarks",
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(data),
  );
}

bookmarkDelete(userId, place_id) async {
  String url = URL;
  var response = await http
      .delete(url + "/api/bookmarks?user_id=$userId&place_id=$place_id");
}

bookmarkSelect(userId, place_id) async {
  String url = URL;
  var response =
      await http.get(url + "/api/bookmarks?user_id=$userId&place_id=$place_id");
  return json.decode(response.body)["data"]["rowCount"];
}
