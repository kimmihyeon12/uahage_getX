import 'dart:convert';

import 'package:uahage/src/Controller/user.controller.dart';
import 'package:uahage/src/Static/url.dart';
import 'package:http/http.dart' as http;

reviewReport(list, reviewId, desc) async {
  String url = URL;
  var currentData;
  List categoryIdList = [];
  for (int i = 0; i < list.length; i++) {
    if (list[i].toString() == true.toString()) {
      categoryIdList.add(i + 1);
    }
    ;
  }
  Map<String, dynamic> jsonData = {
    "categoryIdList": categoryIdList,
    "reviewId": reviewId,
    "userId": UserController.to.userId.value,
    "desc": desc
  };

  try {
    var response = await http.post(
      url + "/api/places/restaurants/reviews/decl",
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'bearer ${UserController.to.token.value}'
      },
      body: jsonEncode(jsonData),
    );
    return true;
  } catch (err) {
    return Future.error(err);
  }
}
