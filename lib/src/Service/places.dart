import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:uahage/src/Controller/location.controller.dart';
import 'package:uahage/src/Controller/user.controller.dart';
import 'package:uahage/src/Model/craftRooms.dart';
import 'package:uahage/src/Model/dayCareCenter.dart';
import 'dart:convert';
import 'dart:async';
import 'package:uahage/src/Model/kidCafe.dart';
import 'package:uahage/src/Model/experienceCenter.dart';
import 'package:uahage/src/Model/restaurant.dart';
import 'package:uahage/src/Controller/place.controller.dart';
import 'package:uahage/src/Static/url.dart';
import 'package:uahage/src/Model/hospitals.dart';

class Place extends GetView<PlaceController> {
  static getPlaceName(placeCode) {
    if (placeCode == 1) {
      return "restaurants";
    } else if (placeCode == 2) {
      return "hospitals";
    } else if (placeCode == 3) {
      return "day-care-centers";
    } else if (placeCode == 5) {
      return "kid-cafes";
    } else if (placeCode == 6) {
      return "experience-centers";
    } else if (placeCode == 8) {
      return "craft-rooms";
    }
  }

  Future<List<dynamic>> getPlaceList(placeCode) async {
    String url = URL;
    String placeName;
    var pageNumber = controller.placePageNumber();
    placeName = await getPlaceName(placeCode);

    var response;
    if (placeName == "restaurants") {
      response = await http.get(
        Uri.parse(url +
            '/api/places/$placeName?lat=${LocationController.to.lat.value}&lon=${LocationController.to.lon.value}&userId=${UserController.to.userId}&babyBed=&babyChair=&babyMenu=&babyTableware&stroller=&diaperChange&meetingRoom&nursingRoom&playRoom&parking=&isBookmarked=&pageNumber=$pageNumber'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': '${UserController.to.token.value}'
        },
      );
    } else {
      response = await http.get(
        Uri.parse(url +
            '/api/places/$placeName?pageNumber=$pageNumber&lat=${LocationController.to.lat.value}&lon=${LocationController.to.lon.value}'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': '${UserController.to.token.value}'
        },
      );
    }
    List responseJson = json.decode(response.body)["data"]["data"];

    var currentData;
    for (var data in responseJson) {
      print(data);
      if (placeCode == 1) {
        // data.total == null ? "0" : data["total"];
        currentData = Restaurant.fromJson(data);
      } else if (placeCode == 2) {
        currentData = Hospitals.fromJson(data);
      } else if (placeCode == 3) {
        currentData = DayCareCenter.fromJson(data);
      } else if (placeCode == 5) {
        currentData = KidCafe.fromJson(data);
      } else if (placeCode == 6) {
        currentData = Experiencecenter.fromJson(data);
      } else if (placeCode == 8) {
        currentData = CraftRooms.fromJson(data);
      }

      await controller.setPlace(currentData);
      await controller.setPlacePaceNumber();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
