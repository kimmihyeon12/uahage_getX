import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:uahage/src/Controller/location.controller.dart';
import 'package:uahage/src/Controller/user.controller.dart';
import 'dart:convert';
import 'dart:async';
import 'package:uahage/src/Model/kidCafe.dart';
import 'package:uahage/src/Model/experienceCenter.dart';
import 'package:uahage/src/Model/restaurant.dart';
import 'package:uahage/src/Controller/place.controller.dart';
import 'package:uahage/src/Static/url.dart';
import 'package:uahage/src/Model/hospitals.dart';

class Place extends GetView<PlaceController> {
  Future<List<dynamic>> getPlaceList(placeCode) async {
    String url = URL;
    String placeName;
    var pageNumber = controller.placePageNumber();
    if (placeCode == 1) {
      placeName = "restaurants";
    } else if (placeCode == 2) {
      placeName = "hospitals";
    } else if (placeCode == 3) {
      placeName = "day-care-centers";
    } else if (placeCode == 5) {
      placeName = "kid-cafes";
    } else if (placeCode == 6) {
      placeName = "experience-centers";
    }
    var response;
    if (placeName == "restaurants") {
      response = await http.get(url +
          '/api/places/$placeName?pageNumber=$pageNumber&lat=${LocationController.to.lat.value}&lon=${LocationController.to.lon.value}&userId=${UserController.to.userId}&babyBed=&babyChair=&babyMenu=&babyTableware&stroller=&diaperChange&meetingRoom&nursingRoom&playRoom&parking=&isBookmarked=');
    } else {
      response = await http.get(url +
          '/api/places/$placeName?pageNumber=$pageNumber&lat=${LocationController.to.lat.value}&lon=${LocationController.to.lon.value}');
    }
    List responseJson = json.decode(response.body)["data"]["data"];

    var currentData;
    for (var data in responseJson) {
      print(data);
      if (placeCode == 1) {
        currentData = Restaurant.fromJson(data);
      } else if (placeCode == 2) {
        currentData = Hospitals.fromJson(data);
      } else if (placeCode == 5) {
        currentData = KidCafe.fromJson(data);
      } else if (placeCode == 6) {
        currentData = Experiencecenter.fromJson(data);
      }
      print(currentData);
      await controller.setPlace(currentData);
      await controller.setPlacePaceNumber();
    }
  }

  @override
  Widget build(BuildContext context) {
    Get.put(PlaceController());
    return Container();
  }
}
