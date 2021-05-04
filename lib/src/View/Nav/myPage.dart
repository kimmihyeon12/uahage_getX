import 'dart:convert';

import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:uahage/src/Controller/login.controller.dart';
import 'package:uahage/src/Static/Widget/progress.dart';
import 'package:uahage/src/Static/url.dart';
import 'package:uahage/src/Static/Font/font.dart';
import 'package:uahage/src/API/user.dart';

class MyPage extends GetView<LoginCotroller> {
  user User = new user();

  var boy_image = [
    './assets/register/boy_grey.png',
    './assets/register/boy_pink.png'
  ];
  var girl_image = [
    './assets/register/girl_grey.png',
    './assets/register/girl_pink.png'
  ];

  Widget build(BuildContext context) {
    User.select();
    ScreenUtil.init(context, width: 1500, height: 2667);
    FocusScopeNode currentFocus = FocusScope.of(context);

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            children: [
              //Center avatar
              Padding(
                padding: EdgeInsets.only(top: 150.h),
              ),
              Center(
                child: Stack(
                  children: [
                    SizedBox(
                      height: 439.h,
                      width: 439.w,
                      child: CircleAvatar(
                        backgroundImage:
                            AssetImage("./assets/myPage/avatar.png"),
                        child: (() {
                          // your code here

                          if (controller.imageLink.value != "" &&
                              controller.imageLink.value != null) {
                            //print("2 $imageLink");
                            return Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    image: NetworkImage(
                                        controller.imageLink.value),
                                    fit: BoxFit.cover),
                              ),
                            );
                          } else {
                            return Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image:
                                      AssetImage("./assets/myPage/avatar.png"),
                                ),
                              ),
                            );
                          }
                        }()),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        child: InkWell(
                          child: Image.asset(
                            "./assets/myPage/camera.png",
                            height: 109.h,
                            width: 110.w,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Nickname
              Container(
                margin: EdgeInsets.only(top: 31.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      child: controller.nicknames.value == ''
                          ? boldfont("우아하게", 70, Color(0xff3a3939))
                          : boldfont(controller.nicknames.value, 70,
                              Color(0xff3a3939)),
                    ),
                    Container(
                      child: InkWell(
                        onTap: () async {
                          Get.toNamed("/userMotify");
                          User.select();
                        },
                        child: Image.asset(
                          "./assets/myPage/button1_pink.png",
                          width: 361.w,
                          height: 147.h,
                        ),
                      ),
                    )
                  ],
                ),
              ),

              //Gender
              Container(
                margin: EdgeInsets.fromLTRB(99.w, 35.h, 0, 0),
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 아이성별
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 24.h, 56.w, 0),
                      child: Text("아이성별",
                          style: TextStyle(
                              color: const Color(0xffff7292),
                              fontFamily: "NotoSansCJKkr_Medium",
                              fontSize: 57.sp),
                          textAlign: TextAlign.left),
                    ),
                    Container(
                      height: 362.h,
                      width: 262.w,
                      child: InkWell(
                        child: Image.asset(controller.boy.value == true
                            ? boy_image[0]
                            : boy_image[1]),
                      ),
                    ),
                    Container(
                      height: 362.h,
                      width: 262.w,
                      margin: EdgeInsets.only(left: 98.w),
                      child: InkWell(
                        child: Image.asset(controller.girl.value == true
                            ? boy_image[0]
                            : boy_image[1]),
                      ),
                    ),
                  ],
                ),
              ),

              // Birthday
              Container(
                margin: EdgeInsets.fromLTRB(99.w, 5.h, 0, 0),
                child: Row(
                  children: [
                    // 아이생일
                    Text("아이생일",
                        style: TextStyle(
                          fontSize: 57.sp,
                          color: const Color(0xffff7292),
                          fontFamily: "NotoSansCJKkr_Medium",
                        ),
                        textAlign: TextAlign.left),
                    Expanded(
                      flex: 1,
                      child: Container(
                        margin: EdgeInsets.fromLTRB(82.w, 0, 121.w, 0),
                        child: Stack(
                          children: [
                            AbsorbPointer(
                              child: TextFormField(
                                readOnly: true,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    color: Color(0xffff7292),
                                    fontSize: 57.sp,
                                    fontFamily: 'NotoSansCJKkr_Medium',
                                    fontStyle: FontStyle.normal,
                                    letterSpacing: -1.0),
                                decoration: InputDecoration(
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: const Color(0xffff7292),
                                    ),
                                    //Color.fromRGBO(255, 114, 148, 1.0)
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Color(0xffff7292)),
                                  ),
                                  hintText:
                                      "${controller.birthdays.value}" == ''
                                          ? "생년월일을 선택해주세요"
                                          : "${controller.birthdays.value}",
                                  hintStyle: TextStyle(
                                      color:
                                          "${controller.birthdays.value}" == ''
                                              ? Color(0xffd4d4d4)
                                              : Color(0xffff7292),
                                      fontFamily: "NotoSansCJKkr_Medium",
                                      fontSize: 57.0.sp),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Ages
              Container(
                margin: EdgeInsets.fromLTRB(155.w, 91.h, 0, 0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 보호자 연령대
                    Text("보호자\n연령대",
                        style: TextStyle(
                          color: const Color(0xffff7292),
                          fontWeight: FontWeight.w500,
                          fontFamily: "NotoSansCJKkr_Medium",
                          fontSize: 57.sp,
                        ),
                        textAlign: TextAlign.right),
                    Container(
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(left: 59.w),
                                child: Image.asset(
                                  controller.ageImage[0] == true
                                      ? './assets/register/10_pink.png'
                                      : './assets/register/10_grey.png',
                                  height: 194.h,
                                  width: 249.w,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 55.w),
                                child: Image.asset(
                                  controller.ageImage[1] == true
                                      ? './assets/register/20_pink.png'
                                      : './assets/register/20_grey.png',
                                  height: 194.h,
                                  width: 249.w,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 55.w),
                                child: Image.asset(
                                  controller.ageImage[2] == true
                                      ? './assets/register/30_pink.png'
                                      : './assets/register/30_grey.png',
                                  height: 194.h,
                                  width: 249.w,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(left: 59.w, top: 45.h),
                                child: Image.asset(
                                  controller.ageImage[3] == true
                                      ? './assets/register/40_pink.png'
                                      : './assets/register/40_grey.png',
                                  height: 194.h,
                                  width: 249.w,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 55.w, top: 45.h),
                                child: Image.asset(
                                  controller.ageImage[4] == true
                                      ? './assets/register/50_pink.png'
                                      : './assets/register/50_grey.png',
                                  height: 194.h,
                                  width: 249.w,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 55.w, top: 45.h),
                                child: Image.asset(
                                  controller.ageImage[5] == true
                                      ? './assets/register/others_pink.png'
                                      : './assets/register/others_grey.png',
                                  height: 194.h,
                                  width: 249.w,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Ok Button

              //logout
              Container(
                margin: EdgeInsets.fromLTRB(931.w, 370.h, 0, 71.h),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.0)),
                            ),
                            title: // 로그아웃 하시겠습니까?
                                Text("로그아웃 하시겠습니까?",
                                    style: TextStyle(
                                        color: const Color(0xff4d4d4d),
                                        fontWeight: FontWeight.w500,
                                        fontFamily: "NotoSansCJKkr_Medium",
                                        fontStyle: FontStyle.normal,
                                        fontSize: 55.sp),
                                    textAlign: TextAlign.left),
                            actions: [
                              FlatButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: normalfont("아니요", 55, Color(0xffff7292)),
                              ),
                              FlatButton(
                                onPressed: () async {
                                  SharedPreferences prefs =
                                      await SharedPreferences.getInstance();
                                  // await prefs.remove("uahageUserEmail");
                                  // await prefs.remove("uahageLoginOption");
                                  await prefs.clear();
                                  Navigator.pop(context);
                                  Get.offAllNamed('/login');
                                },
                                child: normalfont("네", 55, Color(0xffff7292)),
                              ),
                            ],
                          ),
                        );
                      },
                      child: // 로그아웃
                          normalfont("로그아웃", 52, Color(0xffb1b1b1)),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 15.w, right: 15.w),
                      child: normalfont("|", 52, Color(0xffb1b1b1)),
                    ),
                    InkWell(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.0)),
                            ),
                            title: normalfont(
                                "탈퇴하시겠습니까? 탈퇴 시 기존 데이터를 복구할 수 없습니다.",
                                55,
                                Color(0xff4d4d4d)),
                            actions: [
                              FlatButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: normalfont("아니요", 55, Color(0xffff7292)),
                              ),
                              FlatButton(
                                onPressed: () async {
                                  Navigator.pop(context);
                                  SharedPreferences prefs =
                                      await SharedPreferences.getInstance();
                                  // await prefs.clear();

                                  //delete data in the database
                                  showDialog(
                                    context: context,
                                    builder: (_) => FutureBuilder(
                                      future: User.delete(),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          WidgetsBinding.instance
                                              .addPostFrameCallback((_) async {
                                            await prefs.clear();
                                            controller.initsetting();
                                            Get.offNamed("/withdrawal");
                                          });
                                        } else if (snapshot.hasError) {
                                          return AlertDialog(
                                            title: Text("${snapshot.error}"),
                                          );
                                        }

                                        return Center(
                                          child: SizedBox(
                                            height: 200.h,
                                            width: 200.w,
                                            child: progress(),
                                          ),
                                        );
                                      },
                                    ),
                                  );
                                },
                                child: // 네
                                    normalfont("예", 55, Color(0xffff7292)),
                              ),
                            ],
                          ),
                        );
                      },
                      child: normalfont("회원탈퇴", 55, Color(0xffb1b1b1)),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
