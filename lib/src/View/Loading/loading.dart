import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uahage/src/Controller/user.controller.dart';
import 'package:uahage/src/Service/location.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/services.dart';

class Loading extends GetView<UserController> {
  Location location = new Location();
  lodingTime() async {
    await location.setCurrentLocation();
    await 1.delay();

    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (prefs.getString('uahageUserId') != null) {
      controller.setUserid(prefs.getString('uahageUserId'));
      controller.setToken(prefs.getString('uahageUserToken'));
      Get.offNamed("/navigator");
    } else {
      Get.offNamed("/login");
      //  Get.offNamed("/withdrawal");
    }
  }

  connection() async {
    ConnectivityResult connectResult;
    connectResult = await Connectivity().checkConnectivity();
    print(connectResult);
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    connection();
    lodingTime();
    ScreenUtil.init(context, width: 1500, height: 2667);

    return Scaffold(
      backgroundColor: Color(0xfffff1f0),
      body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/LoadingPage/loadingbackground.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: [
              Padding(padding: EdgeInsets.only(top: 875.h)),
              Container(
                width: 1500.w,
              ),
              Image.asset(
                "assets/LoadingPage/logo.png",
                width: 339.w,
              ),
              Padding(padding: EdgeInsets.only(top: 47.5.h)),
              Image.asset(
                "assets/LoadingPage/loadingtext.png",
                width: 666.w,
              ),
              Padding(padding: EdgeInsets.only(top: 1.h)),
              Image.asset(
                "assets/LoadingPage/loadingtext1.png",
                width: 462.w,
              ),
              Padding(padding: EdgeInsets.only(top: 827.8.h)),
              Image.asset(
                "assets/LoadingPage/hohocompany.png",
                width: 458.w,
              )
            ],
          )),
    );
  }
}
