import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:uahage/src/Controller/user.controller.dart';
import 'package:uahage/src/Static/Font/font.dart';

class Login extends GetView<UserController> {
  @override
  Widget build(context) {
    ScreenUtil.init(context, width: 1501, height: 2667);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(padding: EdgeInsets.only(top: 281.h)),
              Container(
                margin: EdgeInsets.only(left: 154.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    normalfont("편리한 일상을", 120, Color(0xff3a3939)),
                    boldfont("우아하게를 통해", 120, Color(0xff3a3939)),
                    boldfont("만나보세요!", 120, Color(0xff3a3939)),
                  ],
                ),
              ),
              Padding(padding: EdgeInsets.only(top: 1166.h)),
              Container(
                margin: EdgeInsets.only(left: 429.w),
                child: Image.asset(
                  "assets/LoginPage/loginpagetext.png",
                  width: 641.w,
                ),
              ),
              Padding(padding: EdgeInsets.only(top: 54.h)),
              Container(
                margin: EdgeInsets.only(left: 489.w),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () async {
                        controller.setOption("KAKAO");
                        Get.toNamed("/agreement");
                      },
                      child: Container(
                        height: 208.h,
                        width: 208.w,
                        decoration: BoxDecoration(
                          color: Color(0xffff3d84a),
                          shape: BoxShape.circle,
                        ),
                        child: Container(
                          margin: EdgeInsets.all(15),
                          child: Image.asset(
                            "assets/LoginPage/kakao.png",
                            width: 90.w,
                          ),
                        ),
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(left: 104.w)),
                    InkWell(
                      onTap: () {
                        controller.setOption("NAVER");
                        Get.toNamed("/agreement");
                      },
                      child: Container(
                        height: 208.h,
                        width: 208.w,
                        decoration: BoxDecoration(
                          color: Color(0xfff6dcd00),
                          shape: BoxShape.circle,
                        ),
                        child: Container(
                          margin: EdgeInsets.all(18),
                          child: Image.asset(
                            "assets/LoginPage/naver.png",
                            width: 62.w,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(padding: EdgeInsets.only(top: 125.h)),
              Container(
                margin: EdgeInsets.only(left: 543.w),
                child: Image.asset(
                  "assets/LoginPage/hohocorp.png",
                  width: 414.w,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
