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
        url + "/places/restaurants/bookmarked",
      ),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': '${UserController.to.token.value}'
      },
      body: jsonEncode(data),
    );
    print(response);
  }

  bookmarkSelectAll(userId) async {
    String url = URL;
    print('user-Id $userId');
    final response = await http.get(
      Uri.parse(URL +
          //   '/places/restaurants?pageNumber=1&lat=${LocationController.to.lat.value}&lon=${LocationController.to.lon.value}&userId=$userId&isBookmarked=true'),
          '/places/restaurants?${LocationController.to.lat.value}&lon=${LocationController.to.lon.value}&userId=${UserController.to.userId}&pageNumber=1&isBookmarked=true'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': '${UserController.to.token.value}'
      },
    );

    List responseJson = jsonDecode(utf8.decode(response.bodyBytes))["places"];
    print(responseJson);
    var currentData;
    for (var data in responseJson) {
      currentData = Restaurant.fromJson(data);

      await controller.setPlaceBookmark(currentData);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
