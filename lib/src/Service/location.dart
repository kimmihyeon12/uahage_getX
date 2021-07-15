import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uahage/src/Controller/location.controller.dart';
import 'package:uahage/src/Static/Font/font.dart';

class Location extends GetView<LocationController> {
  String _latitude = '35.146076';
  String _longitude = '126.9231225';
  bool serviceEnabled;
  LocationPermission permission;

  Future setCurrentLocation() async {
    print("1");
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    print("2");
    if (!serviceEnabled) {
      print('Location services are disabled.');
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    print(permission);

    if (permission == LocationPermission.denied) {
      await Geolocator.requestPermission();
      controller.setLocation('35.146076', '126.9231225');
      return false;
    }

    if (permission == LocationPermission.deniedForever) {
      //  permission = await Geolocator.checkPermission();
      await Geolocator.requestPermission();
      // controller.setLocation('35.146076', '126.9231225');
      return false;
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    var latitude = position.latitude.toString();
    var longitude = position.longitude.toString();

    _latitude = latitude;
    _longitude = longitude;

    controller.setLocation(_latitude, _longitude);

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
