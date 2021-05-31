import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uahage/src/Controller/location.controller.dart';

class Location extends GetView<LocationController> {
  String _latitude;
  String _longitude;

  Future setCurrentLocation() async {
    print("1");
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      print("2");
      if (permission == LocationPermission.denied) {
        _latitude = '35.146076';
        _longitude = '126.9231225';
        return print('Location permissions are denied');
      }
    }
    print("3");
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    print("4");
    var latitude = position.latitude.toString();
    var longitude = position.longitude.toString();

    _latitude = latitude;
    _longitude = longitude;

    controller.setLocation(_latitude, _longitude);
    print("lat ${_latitude} lon ${_longitude}");
    print("3");
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
