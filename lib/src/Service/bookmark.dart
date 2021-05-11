import 'package:flutter_config/flutter_config.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:uahage/src/Controller/bookmark.controller.dart';
import 'package:uahage/src/Controller/user.controller.dart';
import 'dart:convert';
import 'package:uahage/src/Static/url.dart';
import 'package:uahage/src/Model/starHelper.dart';
import 'package:flutter/material.dart';

class Bookmark extends GetView<BookmarkController> {
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
    var response = await http
        .get(url + "/api/bookmarks?user_id=$userId&place_id=$place_id");
    return json.decode(response.body)["data"]["rowCount"] == 1 ? true : false;
  }

  bookmarkSelectAll(userId) async {
    String url = URL;

    final response = await http.get(URL + '/api/bookmarks/?user_id=$userId');
    List responseJson = json.decode(response.body)["data"]["rows"];
    if (json.decode(response.body)["message"] == false) {
    } else {
      var currentData;
      for (var data in responseJson) {
        currentData = StarList.fromJson(data);
        await controller.setStarList(currentData);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
