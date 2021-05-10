import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:uahage/src/Controller/user.controller.dart';

class Login extends GetView<UserController> {
  @override
  Widget build(context) {
    ScreenUtil.init(context, width: 1501, height: 2667);
    Get.put(UserController());
    return Scaffold(
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(588.w, 489.h, 588.w, 0),
                child: Image.asset(
                  "./assets/secondPage/logo.png",
                  height: 357.h,
                  width: 325.w,
                ),
              ),

              // 우리아이와 함께하는
              Container(
                margin: EdgeInsets.fromLTRB(0, 79.h, 0, 0),
                child: RichText(
                  text: TextSpan(children: [
                    TextSpan(
                        style: TextStyle(
                            color: const Color(0xffff7292),
                            fontWeight: FontWeight.w900,
                            fontFamily: "S_CoreDream_8",
                            fontStyle: FontStyle.normal,
                            fontSize: 80.sp),
                        text: "우리아이와"),
                    TextSpan(
                        style: TextStyle(
                            color: const Color(0xffff7292),
                            fontWeight: FontWeight.w400,
                            fontFamily: "S_CoreDream_4",
                            fontStyle: FontStyle.normal,
                            fontSize: 80.sp),
                        text: "와 함께하는")
                  ]),
                ),
              ),

              // Logo Image
              Container(
                margin: EdgeInsets.fromLTRB(545.w, 49.h, 546.w, 0),
                child: Image.asset("./assets/secondPage/logoName.png"),
              ),

              //hearts
              Container(
                margin: EdgeInsets.fromLTRB(79.w, 71.h, 79.w, 0),
                child: Image.asset("./assets/secondPage/hearts.png"),
              ),

              // kakao
              Container(
                margin: EdgeInsets.fromLTRB(96.w, 69.h, 94.w, 0),
                height: 195.h,
                child: InkWell(
                  onTap: () async {
                    controller.option("kakao");
                    Get.toNamed("/agreement");
                  },
                  child: Image.asset(
                    "./assets/secondPage/kakao.png",
                    height: 195.h,
                    width: 1311.w,
                  ),
                ),
              ),

              // Naver
              Container(
                margin: EdgeInsets.fromLTRB(96.w, 53.h, 94.w, 0),
                height: 195.h,
                child: InkWell(
                  onTap: () {
                    controller.option("naver");
                    Get.toNamed("/agreement");
                  },
                  child: Image.asset("./assets/secondPage/naver.png"),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
