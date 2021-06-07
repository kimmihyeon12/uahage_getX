import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:uahage/src/Controller/user.controller.dart';

import 'package:uahage/src/Static/Font/font.dart';
import 'package:uahage/src/Static/Widget/appbar.dart';
import 'package:uahage/src/Static/Widget/dialog.dart';
import 'package:uahage/src/Static/url.dart';
import 'package:uahage/src/Static/Widget/yearpicker.dart';
import 'package:uahage/src/Static/Widget/progress.dart';

import 'package:uahage/src/Service/users.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  String url = URL;

  Users users = new Users();
  //user
  bool isIdValid = false;
  String birthday = "";
  String nickName = "";
  String gender = "";
  bool boy = true;
  bool girl = true;
  int age = 0;

  TextEditingController yController = TextEditingController();
  var ageImage = [false, false, false, false, false, false];

  var boy_image = [
    './assets/register/boy_grey.png',
    './assets/register/boy_pink.png'
  ];
  var girl_image = [
    './assets/register/girl_grey.png',
    './assets/register/girl_pink.png'
  ];
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 1500, height: 2667);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    FocusScopeNode currentFocus = FocusScope.of(context);
    return SafeArea(
      child: Scaffold(
        appBar: imageAppbar(context, "회원가입"),
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
                      normalfont("닉네임", 58, Color.fromRGBO(255, 114, 148, 1.0)),
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
                                    setState(() {
                                      nickName = value;
                                    });
                                },
                                maxLength: 10,
                                style: TextStyle(
                                  color: const Color(0xff3a3939),
                                  fontFamily: "NotoSansCJKkr_Medium",
                                  fontStyle: FontStyle.normal,
                                  fontSize: 62.5.sp,
                                ),
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.only(right: 20.w),
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
                                  height: 135.h,
                                  child: FlatButton(
                                    shape: new RoundedRectangleBorder(
                                      borderRadius:
                                          new BorderRadius.circular(8.0),
                                    ),
                                    onPressed: nickName != ""
                                        ? () async {
                                            var data = await users
                                                .checkNickName(nickName);
                                            setState(() {
                                              isIdValid = data['idValid'];
                                            });
                                            currentFocus.unfocus();
                                            dialog(
                                              context,
                                              data['value'],
                                            );
                                          }
                                        : () {},
                                    color: nickName == ""
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
                        child: normalfont(
                            "아이성별", 58, Color.fromARGB(255, 255, 114, 148))),
                    Padding(padding: EdgeInsets.only(left: 80.w)),
                    InkWell(
                      onTap: () {
                        setState(() {
                          boy = !boy;
                          gender = "M";
                          if (!girl && boy) {
                            gender = "F";
                          }
                          if (girl && boy) {
                            gender = "";
                          }
                          if (!girl && !boy) {
                            gender = "A";
                          }
                          print(gender);
                        });
                      },
                      child: Column(children: <Widget>[
                        Container(
                          height: 362.h,
                          width: 262.w,
                          child: Image.asset(boy ? boy_image[0] : boy_image[1]),
                        ),
                        Padding(padding: EdgeInsets.only(bottom: 11)),
                      ]),
                    ),
                    Padding(padding: EdgeInsets.only(left: 98.w)),
                    InkWell(
                      onTap: () {
                        setState(() {
                          girl = !girl;
                          gender = "F";
                          if (girl && !boy) {
                            gender = "M";
                          }
                          if (girl && boy) {
                            gender = "";
                          }
                          if (!girl && !boy) {
                            gender = "A";
                          }
                          print(gender);
                        });
                      },
                      child: Column(children: <Widget>[
                        Container(
                          height: 362.h,
                          width: 262.w,
                          child:
                              Image.asset(girl ? girl_image[0] : girl_image[1]),
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
                    normalfont("아이생일", 58, Color.fromARGB(255, 255, 114, 148)),
                    Expanded(
                      flex: 1,
                      child: Container(
                        margin: EdgeInsets.fromLTRB(82.w, 0, 118.w, 0),
                        child: Stack(
                          children: [
                            GestureDetector(
                              onTap: () async {
                                var result = await yearPicker(context);
                                setState(() {
                                  birthday = result;
                                });
                              },
                              child: AbsorbPointer(
                                child: TextFormField(
                                  controller: yController,
                                  onChanged: (txt) {
                                    setState(() {
                                      birthday = txt;
                                    });
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
                                    hintText: birthday == ''
                                        ? "생년월일을 선택해주세요"
                                        : birthday,
                                    hintStyle: TextStyle(
                                        color: birthday == ''
                                            ? Color(0xffd4d4d4)
                                            : Color(0xffff7292),
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
                                onPressed: () async {
                                  var result = await yearPicker(context);
                                  setState(() {
                                    birthday = result;
                                  });
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
                    normalfont(
                        "보호자\n 연령대", 58, Color.fromARGB(255, 255, 114, 148)),
                    Padding(padding: EdgeInsets.only(left: 62.w)),
                    InkWell(
                      child: Image.asset(
                        ageImage[0]
                            ? './assets/register/10_pink.png'
                            : './assets/register/10_grey.png',
                        height: 196.h,
                        width: 251.w,
                      ),
                      onTap: () {
                        setAgeColor(1);
                      },
                    ),
                    Padding(padding: EdgeInsets.only(left: 55.w)),
                    InkWell(
                      child: Image.asset(
                        ageImage[1]
                            ? './assets/register/20_pink.png'
                            : './assets/register/20_grey.png',
                        height: 196.h,
                        width: 251.w,
                      ),
                      onTap: () {
                        setAgeColor(2);
                      },
                    ),
                    Padding(padding: EdgeInsets.only(left: 55.w)),
                    InkWell(
                      child: Image.asset(
                        ageImage[2]
                            ? './assets/register/30_pink.png'
                            : './assets/register/30_grey.png',
                        height: 196.h,
                        width: 251.w,
                      ),
                      onTap: () {
                        setAgeColor(3);
                      },
                    ),
                  ],
                ),
                Padding(padding: EdgeInsets.only(top: 25.w)),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(padding: EdgeInsets.only(left: 147.w)),
                    normalfont("보호자\n 연령대", 58, Colors.transparent),
                    Padding(padding: EdgeInsets.only(left: 62.w)),
                    InkWell(
                      child: Image.asset(
                        ageImage[3]
                            ? './assets/register/40_pink.png'
                            : './assets/register/40_grey.png',
                        height: 196.h,
                        width: 251.w,
                      ),
                      onTap: () {
                        setAgeColor(4);
                      },
                    ),
                    Padding(padding: EdgeInsets.only(left: 55.w)),
                    InkWell(
                      child: Image.asset(
                        ageImage[4]
                            ? './assets/register/50_pink.png'
                            : './assets/register/50_grey.png',
                        height: 196.h,
                        width: 251.w,
                      ),
                      onTap: () {
                        setAgeColor(5);
                      },
                    ),
                    Padding(padding: EdgeInsets.only(left: 55.w)),
                    InkWell(
                      child: Image.asset(
                        ageImage[5]
                            ? './assets/register/others_pink.png'
                            : './assets/register/others_grey.png',
                        height: 196.h,
                        width: 251.w,
                      ),
                      onTap: () {
                        setAgeColor(6);
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
                  onPressed: isIdValid == true &&
                          age != 0 &&
                          gender != "" &&
                          birthday != "" &&
                          nickName != ""
                      ? () async {
                          showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (context) => FutureBuilder(
                              future: users.insert("withNickname", nickName,
                                  gender, birthday, age),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  WidgetsBinding.instance
                                      .addPostFrameCallback((_) async {
                                    Navigator.pop(context);
                                    //if (controller.error.value == false) {
                                    Get.offNamed("/navigator");
                                    //  }
                                  });
                                } else if (snapshot.hasError) {
                                  dialog(context, snapshot);
                                }
                                return progress();
                              },
                            ),
                          );
                        }
                      : () {
                          if (isIdValid == false) {
                            dialog(context, "닉네임 중복을 확인해주세요");
                          }
                        },
                  color: isIdValid == true &&
                          age != 0 &&
                          gender != "" &&
                          birthday != "" &&
                          nickName != ""
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
                        future:
                            users.insert("", nickName, gender, birthday, age),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            WidgetsBinding.instance
                                .addPostFrameCallback((_) async {
                              Navigator.pop(context);
                              //  if (controller.error.value == false) {
                              Get.offNamed("/navigator");
                              //  }
                            });
                          } else if (snapshot.hasError) {
                            dialog(context, snapshot);
                          }
                          return progress();
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

  setAgeColor(int value) {
    age = value;
    for (int i = 0; i < ageImage.length; i++) {
      setState(() {
        if ((value - 1) == i) {
          ageImage[i] = true;
        } else
          ageImage[i] = false;
      });
    }
  }
}
