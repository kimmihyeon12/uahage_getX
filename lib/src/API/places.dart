import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:uahage/src/Controller/location.controller.dart';
import 'dart:convert';
import 'dart:async';
import 'package:uahage/src/Model/kidsCafeHelper.dart';
import 'package:uahage/src/Model/experienceCenter.dart';
import 'package:uahage/src/Model/restaurantHelper.dart';
import 'package:uahage/src/Model/examinationInstitutionHelper.dart';
import 'package:uahage/src/Controller/place.controller.dart';
import '../Controller/login.controller.dart';
import '../Static/url.dart';

class Place extends GetView<PlaceController> {
  Future<List<dynamic>> getPlaceList(placeCode) async {
    String url = URL;
    var pageNumber = controller.placePageNumber();

    final response = await http.get(url +
        '/api/places?place_code=$placeCode&lat=${LocationController.to.lat.value}&lon=${LocationController.to.lon.value}&pageNumber=$pageNumber&user_id=${LoginCotroller.to.userId}');
    List responseJson = json.decode(response.body)["data"]["rows"];
    if (json.decode(response.body)["message"] == false) {
    } else {
      var currentData;
      for (var data in responseJson) {
        if (placeCode == 1) {
          currentData = Restaurant.fromJson(data);
        } else if (placeCode == 2) {
          currentData = Examinationinstitution.fromJson(data);
        } else if (placeCode == 5) {
          currentData = KidsCafe.fromJson(data);
        } else if (placeCode == 6) {
          currentData = Experiencecenter.fromJson(data);
        }
        controller.setPlace(currentData);
        controller.setPlacePaceNumber();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
