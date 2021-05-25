import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uahage/src/Controller/user.controller.dart';
import 'package:uahage/src/Service/location.dart';

class Loading extends GetView<UserController> {
  Location location = new Location();
  lodingTime() async {
    await location.setCurrentLocation();
    await 1.delay();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //  Get.offNamed("/login");
    if (prefs.getString('uahageUserId') != null) {
      controller.setUserid(prefs.getString('uahageUserId'));
      controller.setToken(prefs.getString('uahageUserToken'));
      Get.offNamed("/navigator");
    } else {
      Get.offNamed("/login");
    }
  }

  @override
  Widget build(BuildContext context) {
    lodingTime();
    ScreenUtil.init(context, width: 1500, height: 2667);
    return Scaffold(
        backgroundColor: Color(0xfffff1f0),
        body: Stack(
          children: [
            Container(
              alignment: Alignment.bottomCenter,
              child: Image(
                image: AssetImage('./assets/firstPage/backfamily.png'),
                width: 1446.w,
              ),
            ),
            Row(
              children: [
                Padding(
                    padding: EdgeInsets.only(
                  left: 658.w,
                )),
                Image(
                  image: AssetImage('./assets/firstPage/Lighting.png'),
                  height: 440.h,
                  width: 143.w,
                ),
                Image(
                  image: AssetImage('./assets/firstPage/logo.png'),
                  height: 88.h,
                  width: 662.w,
                ),
              ],
            ),
            Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 666.h, 0, 0),
                    child: Image(
                      image: AssetImage('./assets/firstPage/group.png'),
                      height: 357.h,
                      width: 325.w,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 79.h, 0, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "우리아이",
                          style: TextStyle(
                              fontFamily: "S_CoreDream_8",
                              //   height: 1.0,
                              //   letterSpacing: -1.0,
                              fontSize: 71.h,
                              // fontWeight: FontWeight.bold,
                              color: Color.fromRGBO(255, 114, 148, 1.0)),
                        ),
                        Text(
                          "와 함께하는",
                          style: TextStyle(
                              fontFamily: "S_CoreDream_4",
                              fontSize: 71.h,
                              color: Color.fromRGBO(255, 114, 148, 1.0)),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 49.h, 0, 0),
                    child: Image(
                      image: AssetImage('./assets/firstPage/uahage.png'),
                      height: 113.h,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
