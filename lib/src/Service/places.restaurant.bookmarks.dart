import 'package:get/get.dart';
import 'package:uahage/src/Controller/location.controller.dart';
import 'package:uahage/src/Controller/place.restaurant.bookmark.controller.dart';
import 'package:uahage/src/Controller/user.controller.dart';
import 'package:uahage/src/Model/restaurant.dart';
import 'package:uahage/src/Static/url.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';

class Bookmark extends GetView<BookmarkController> {
  bookmarkToogle(userId, placeId) async {
    String url = URL;
    var data = {"userId": userId, "placeId": placeId};
    var response = await http.post(
      Uri.parse(
        url + "/api/places/restaurants/bookmarks",
      ),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': '${UserController.to.token.value}'
      },
      body: jsonEncode(data),
    );
  }

  bookmarkSelectAll(userId) async {
    String url = URL;

    final response = await http.get(
      Uri.parse(URL +
          '/api/places/restaurants?pageNumber=0&lat=${LocationController.to.lat.value}&lon=${LocationController.to.lon.value}&userId=$userId&babyBed=&babyChair=&babyMenu=&babyTableware&stroller=&diaperChange&meetingRoom&nursingRoom&playRoom&parking=&isBookmarked=1'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': '${UserController.to.token.value}'
      },
    );

    List responseJson = json.decode(response.body)["data"]["data"];

    var currentData;
    for (var data in responseJson) {
      currentData = Restaurant.fromJson(data);
      print(data);
      await controller.setPlaceBookmark(currentData);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
