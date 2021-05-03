import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:uahage/src/Controller/login.controller.dart';

class register extends GetView<loginCotroller> {
  String url = "http://121.148.172.38:8000";
  var boy_image = [
    './assets/register/boy_grey.png',
    './assets/register/boy_pink.png'
  ];
  var girl_image = [
    './assets/register/girl_grey.png',
    './assets/register/girl_pink.png'
  ];

  //check nickname
  Future checkNickName() async {
    try {
      var response = await http.get(
        url +
            "/api/users/find-by-option?option=nickname&optionData='${controller.nicknames.value}'",
      );
      print("isdata nickname" + jsonDecode(response.body)["isdata"].toString());
      if (jsonDecode(response.body)["isdata"] == 0) {
        controller.idValidstate(true);

        return "사용 가능한 닉네임입니다.";
      } else {
        controller.idValidstate(false);
        return "이미 사용중인 닉네임입니다.";
      }
    } catch (err) {
      print(err);
      return Future.error(err);
    }
  }

  Future signUp(String type) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    Map<String, dynamic> userData = type == "withNickname"
        ? {
            "email":
                "'${controller.emails.value}${controller.loginOption.value}'",
            "nickname": "'${controller.nicknames.value}'",
            "gender": "'${controller.genders.value}'",
            "birthday": "'${controller.birthdays.value}'",
            "age": controller.ages,
            "URL": null,
            "rf_token": null
          }
        : {
            "email":
                "'${controller.emails.value}${controller.loginOption.value}'",
            "nickname": null,
            "gender": null,
            "birthday": null,
            "age": null,
            "URL": null,
            "rf_token": null
          };
    try {
      var response = await http.post(
        url + "/api/auth/signup",
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(userData),
      );

      if (response.statusCode == 200) {
        controller.errorstate(false);

        var data = jsonDecode(response.body);
        String token = data['data']['token'];
        String userId = data['data']['id'].toString();

        //save user info
        await sharedPreferences.setString("uahageUserToken", token);
        await sharedPreferences.setString("uahageUserId", userId);

        controller.setUserid(userId);
        controller.setToken(token);

        return data["message"];
      } else {
        controller.errorstate(true);
        return Future.error(jsonDecode(response.body)["message"]);
      }
    } catch (error) {
      return Future.error(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 1500, height: 2667);
    var _fontsize = 62.5.sp;
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    FocusScopeNode currentFocus = FocusScope.of(context);

    return SafeArea(
      child: Scaffold(
        //appBar: appbar()
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(padding: EdgeInsets.only(top: 250.h)),

              //membership_Nickname

              Container(
                child: Container(
                  child: Row(
                    children: [
                      Padding(padding: EdgeInsets.only(left: 150.w)),
                      Text(
                        "닉네임",
                        style: TextStyle(
                            fontSize: 58.sp,
                            color: Color.fromARGB(255, 255, 114, 148),
                            fontFamily: 'NotoSansCJKkr_Medium'),
                      ),
                      Padding(padding: EdgeInsets.only(left: 88.w)),
                      Expanded(
                        flex: 1,
                        child: Container(
                          margin: EdgeInsets.only(right: 121.sp),
                          child: Stack(
                            children: [
                              TextFormField(
                                onChanged: (value) {
                                  if (value.length <= 10)
                                    controller.setnickname(value);
                                },
                                maxLength: 10,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  color: const Color(0xff3a3939),
                                  fontFamily: "NotoSansCJKkr_Medium",
                                  fontStyle: FontStyle.normal,
                                  fontSize: 62.5.sp,
                                ),
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.only(right: 410.w),
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
                                  hintText: '닉네임을 입력하세요',
                                  hintStyle: TextStyle(
                                      color: Color(0xffcccccc),
                                      fontSize: 58.sp,
                                      letterSpacing: -1.0),
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: Container(
                                  width: 350.w,
                                  height: 125.h,
                                  child: FlatButton(
                                    shape: new RoundedRectangleBorder(
                                      borderRadius:
                                          new BorderRadius.circular(8.0),
                                    ),
                                    onPressed: controller.nicknames.value != ""
                                        ? () {
                                            currentFocus.unfocus();
                                          }
                                        : () {},
                                    color: controller.nicknames.value == ""
                                        ? Color(0xffcacaca)
                                        : Color(0xffff7292),
                                    child: Text(
                                      "중복확인",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'NotoSansCJKkr_Medium',
                                        fontSize: 58.sp,
                                      ),
                                    ),
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
              ),
              Padding(padding: EdgeInsets.only(top: 110.h)),

              //baby_Gender
              Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(padding: EdgeInsets.only(left: 91.w)),
                    Container(
                      child: Text(
                        "아이성별",
                        style: TextStyle(
                            fontSize: 58.sp,
                            color: Color.fromARGB(255, 255, 114, 148),
                            fontFamily: 'NotoSansCJKkr_Medium'),
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(left: 80.w)),
                    InkWell(
                      onTap: () {
                        controller.setGenderColor('M');
                      },
                      child: Column(children: <Widget>[
                        Container(
                          height: 362.h,
                          width: 262.w,
                          child: Image.asset(controller.boy.value == true
                              ? boy_image[0]
                              : boy_image[1]),
                        ),
                        Padding(padding: EdgeInsets.only(bottom: 11)),
                      ]),
                    ),
                    Padding(padding: EdgeInsets.only(left: 98.w)),
                    InkWell(
                      onTap: () {
                        controller.setGenderColor('F');
                      },
                      child: Column(children: <Widget>[
                        Container(
                          height: 362.h,
                          width: 262.w,
                          child: Image.asset(controller.girl.value == true
                              ? girl_image[0]
                              : girl_image[1]),
                        ),
                        Padding(padding: EdgeInsets.only(bottom: 11)),
                      ]),
                    ),
                  ]),

              //baby_birtyday
              Container(
                margin: EdgeInsets.fromLTRB(99.w, 20.h, 0, 0),
                child: Row(
                  children: [
                    // 아이생일
                    Text(
                      "아이생일",
                      style: TextStyle(
                          fontSize: 58.sp,
                          color: Color.fromARGB(255, 255, 114, 148),
                          fontFamily: 'NotoSansCJKkr_Medium'),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        margin: EdgeInsets.fromLTRB(82.w, 0, 118.w, 0),
                        child: Stack(
                          children: [
                            GestureDetector(
                              //onTap: yearPicker,
                              child: AbsorbPointer(
                                child: TextFormField(
                                  onChanged: (txt) {
                                    controller.setbirthday(txt);
                                  },
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      color: Color(0xffff7292),
                                      fontSize: 73.sp,
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
                                    hintText: '생년월일을 선택해주세요',
                                    hintStyle: TextStyle(
                                        color: Color(0xffd4d4d4),
                                        fontWeight: FontWeight.w500,
                                        fontFamily: "NotoSansCJKkr_Medium",
                                        fontSize: 58.0.sp),
                                  ),
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: IconButton(
                                onPressed: () {
                                  //  yearPicker();
                                },
                                icon: Image.asset(
                                  './assets/register/calendar.png',
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: EdgeInsets.fromLTRB(0, 98.h, 0, 0.h),
              ),
              //Parental age group

              Column(children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(padding: EdgeInsets.only(left: 147.w)),
                    Text(
                      "보호자\n 연령대",
                      textAlign: TextAlign.right,
                      style: TextStyle(
                          fontSize: 57.sp,
                          color: Color.fromARGB(255, 255, 114, 148),
                          fontFamily: 'NotoSansCJKkr_Medium'),
                    ),
                    Padding(padding: EdgeInsets.only(left: 62.w)),
                    InkWell(
                      child: Image.asset(
                        controller.ageImage[0] == true
                            ? './assets/register/10_pink.png'
                            : './assets/register/10_grey.png',
                        height: 196.h,
                        width: 251.w,
                      ),
                      onTap: () {
                        controller.setAgeColor(10);
                      },
                    ),
                    Padding(padding: EdgeInsets.only(left: 55.w)),
                    InkWell(
                      child: Image.asset(
                        controller.ageImage[1] == true
                            ? './assets/register/20_pink.png'
                            : './assets/register/20_grey.png',
                        height: 196.h,
                        width: 251.w,
                      ),
                      onTap: () {
                        controller.setAgeColor(20);
                      },
                    ),
                    Padding(padding: EdgeInsets.only(left: 55.w)),
                    InkWell(
                      child: Image.asset(
                        controller.ageImage[2] == true
                            ? './assets/register/30_pink.png'
                            : './assets/register/30_grey.png',
                        height: 196.h,
                        width: 251.w,
                      ),
                      onTap: () {
                        controller.setAgeColor(30);
                      },
                    ),
                  ],
                ),
                Padding(padding: EdgeInsets.only(top: 25.w)),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(padding: EdgeInsets.only(left: 147.w)),
                    Text(
                      "보호자\n 연령대",
                      textAlign: TextAlign.right,
                      style: TextStyle(
                          fontSize: 57.sp,
                          color: Colors.transparent,
                          fontFamily: 'NotoSansCJKkr_Medium'),
                    ),
                    Padding(padding: EdgeInsets.only(left: 62.w)),
                    InkWell(
                      child: Image.asset(
                        controller.ageImage[3] == true
                            ? './assets/register/40_pink.png'
                            : './assets/register/40_grey.png',
                        height: 196.h,
                        width: 251.w,
                      ),
                      onTap: () {
                        controller.setAgeColor(40);
                      },
                    ),
                    Padding(padding: EdgeInsets.only(left: 55.w)),
                    InkWell(
                      child: Image.asset(
                        controller.ageImage[4] == true
                            ? './assets/register/50_pink.png'
                            : './assets/register/50_grey.png',
                        height: 196.h,
                        width: 251.w,
                      ),
                      onTap: () {
                        controller.setAgeColor(50);
                      },
                    ),
                    Padding(padding: EdgeInsets.only(left: 55.w)),
                    InkWell(
                      child: Image.asset(
                        controller.ageImage[5] == true
                            ? './assets/register/others_pink.png'
                            : './assets/register/others_grey.png',
                        height: 196.h,
                        width: 251.w,
                      ),
                      onTap: () {
                        controller.setAgeColor(60);
                      },
                    ),
                  ],
                ),
              ]),
              Padding(padding: EdgeInsets.only(top: 125.h)),

              //ok button
              Container(
                width: 1193.w,
                height: 194.h,
                // margin: EdgeInsets.only(bottom: 70/(2667/ScreenHeight)),
                child: FlatButton(
                  shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(8.0),
                  ),
                  onPressed: controller.isIdValid.value == true &&
                          controller.ages.value != 0 &&
                          controller.genders.value != "" &&
                          controller.birthdays.value != "" &&
                          controller.nicknames.value != ""
                      ? () async {
                          showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (context) => FutureBuilder(
                                future: signUp("withNickname"),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    WidgetsBinding.instance
                                        .addPostFrameCallback((_) async {
                                      Navigator.pop(context);
                                      controller.error.value == true
                                          ? null
                                          : Get.offAllNamed("/navigator");
                                    });
                                  }
                                }),
                          );
                        }
                      : () {},
                  color: controller.isIdValid.value == true &&
                          controller.ages.value != 0 &&
                          controller.genders.value != "" &&
                          controller.birthdays.value != "" &&
                          controller.nicknames.value != ""
                      ? Color(0xffff7292)
                      : Color(0xffcccccc),
                  child: Text(
                    "OK",
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'NotoSansCJKkr_Medium',
                      fontSize: 57.sp,
                    ),
                  ),
                ),
              ),
              Padding(padding: EdgeInsets.only(top: 270.h)),

              //next
              Center(
                child: FlatButton(
                  onPressed: () async {
                    showDialog(
                      context: context,
                      builder: (context) => FutureBuilder(
                        future: signUp(""),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            WidgetsBinding.instance
                                .addPostFrameCallback((_) async {
                              Navigator.pop(context);
                              if (controller.error.value == false) {
                                Get.offAllNamed("/navigator");
                              }
                            });
                          }
                        },
                      ),
                    );
                  },
                  child: Text(
                    "건너뛰기",
                    style: TextStyle(
                      color: Color.fromRGBO(255, 114, 148, 1.0),
                      fontFamily: 'NotoSansCJKkr_Medium',
                      fontSize: 58.sp,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  /*Center buildCenterProgress(double screenHeight, double screenWidth) {
    return Center(
      child: SizedBox(
          height: 200.h,
          width: 200.w,
          child: buildSpinKitThreeBounce(80, screenWidth)),
    );
  }
*/
/*
  AlertDialog buildAlertDialog(AsyncSnapshot snapshot, double screenWidth,
      BuildContext context, double _fontsize) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0))),
      title:
          // id already exists.
          Text("${snapshot.error}",
              style: TextStyle(
                  color: Color(0xff4d4d4d),
                  fontWeight: FontWeight.w500,
                  fontFamily: "NotoSansCJKkr_Medium",
                  fontStyle: FontStyle.normal,
                  fontSize: 62.5.sp),
              textAlign: TextAlign.left),
      actions: [],
    );
  }

  //picker(캘린더)
  yearPicker() {
    final year = DateTime.now().year;
    // double screenHeight = 2667 / MediaQuery.of(context).size.height;
    // double screenWidth = 1501 / MediaQuery.of(context).size.width;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
          ),
          title: Text(
            '생년월일을 입력하세요',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Color.fromRGBO(255, 114, 148, 1.0),
              fontSize: 56.sp,
            ),
            textAlign: TextAlign.center,
          ),
          content: Container(
              height: MediaQuery.of(context).size.height / 5.0,
              width: MediaQuery.of(context).size.width,
              color: Colors.white,
              child: CupertinoDatePicker(
                initialDateTime: DateTime.now(),
                onDateTimeChanged: (DateTime newDate) async {
                  var datee = newDate.toString().substring(0, 10).split('-');
                  yController.text =
                      datee[0] + "년 " + datee[1] + "월 " + datee[2] + "일";
                },
                minimumYear: 2000,
                maximumYear: year,
                mode: CupertinoDatePickerMode.date,
              )),
          actions: <Widget>[
            FlatButton(
              child: Text(
                '확인',
                style: TextStyle(
                  color: Color.fromRGBO(255, 114, 148, 1.0),
                  fontFamily: 'NotoSansCJKkr_Medium',
                  fontSize: 57.sp,
                ),
              ),
              onPressed: () {
                setState(() {
                  birthday = yController.text;
                  Navigator.of(context).pop();
                });
              },
            ),
          ],
        );
      },
    );
  }*/
}
